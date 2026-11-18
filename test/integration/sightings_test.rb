require "test_helper"

class SightingsTest < ActionDispatch::IntegrationTest
  include ActionCable::TestHelper

  setup do
    sign_in_as users(:ian)
  end

  test "index lists the current user's sightings inside a turbo frame" do
    get sightings_path
    assert_response :success
    assert_select "turbo-frame#sightings"
    assert_match "American Robin", response.body
    assert_match "Bald Eagle", response.body
    assert_no_match "Great Blue Heron", response.body
  end

  test "index filters by lens" do
    get sightings_path, params: { lens_id: lenses(:ultima).id }
    assert_response :success
    assert_match "Bald Eagle", response.body
    assert_no_match "American Robin", response.body
  end

  test "new renders a form with a lens select" do
    get new_sighting_path
    assert_response :success
    assert_select "form select[name='sighting[lens_id]']"
  end

  test "create from the field kit page prepends a stream and broadcasts to the activity feed" do
    item = field_kit_items(:ian_monarch)
    assert_difference "Sighting.count", 1 do
      assert_broadcasts "activity", 1 do
        post sightings_path,
             params: { sighting: { species: "Northern Cardinal", weight: 0.04, length: 0.2, lens_id: lenses(:monarch).id },
                       field_kit_item_id: item.id },
             headers: TURBO_STREAM_HEADERS
      end
    end
    assert_response :success
    assert_equal "text/vnd.turbo-stream.html", response.media_type
    assert_match "<turbo-stream", response.body
    assert_match "sightings_field_kit_item_#{item.id}", response.body
    assert_match "new_sighting", response.body
  end

  test "create with invalid params re-renders the form" do
    post sightings_path, params: { sighting: { species: "" } }
    assert_response :unprocessable_entity
  end

  test "update from a turbo frame replaces the row and broadcasts" do
    sighting = sightings(:robin)
    assert_broadcasts "activity", 1 do
      patch sighting_path(sighting),
            params: { sighting: { species: "European Robin" } },
            headers: TURBO_STREAM_HEADERS.merge("Turbo-Frame" => "sighting_#{sighting.id}")
    end
    assert_response :success
    assert_match "European Robin", response.body
    assert_equal "European Robin", sighting.reload.species
  end

  test "edit renders the inline edit frame" do
    sighting = sightings(:robin)
    get edit_sighting_path(sighting), headers: { "Turbo-Frame" => "sighting_#{sighting.id}" }
    assert_response :success
    assert_select "turbo-frame#sighting_#{sighting.id} form"
  end

  test "destroy removes the sighting with a stream and broadcasts" do
    sighting = sightings(:robin)
    assert_difference "Sighting.count", -1 do
      assert_broadcasts "activity", 1 do
        delete sighting_path(sighting), headers: TURBO_STREAM_HEADERS
      end
    end
    assert_response :success
    assert_match "remove", response.body
    assert_match "sighting_#{sighting.id}", response.body
  end

  test "like increments likes_count and replaces the like button via stream" do
    sighting = sightings(:heron)
    assert_difference -> { sighting.reload.likes_count }, 1 do
      assert_broadcasts "activity", 1 do
        post like_sighting_path(sighting), headers: TURBO_STREAM_HEADERS
      end
    end
    assert_response :success
    assert_match "like_sighting_#{sighting.id}", response.body
  end

  test "edit is forbidden for other users' sightings" do
    get edit_sighting_path(sightings(:heron))
    assert_redirected_to sightings_path
  end

  test "requires signin" do
    delete session_path
    get sightings_path
    assert_redirected_to signin_path
  end
end
