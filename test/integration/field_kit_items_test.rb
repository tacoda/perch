require "test_helper"

class FieldKitItemsTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:ian)
  end

  test "index redirects to the kit item for the most recent sighting" do
    get field_kit_items_path
    assert_redirected_to field_kit_item_path(field_kit_items(:ian_monarch))
  end

  test "show renders the kit page with stats, form and framed sighting rows" do
    item = field_kit_items(:ian_monarch)
    get field_kit_item_path(item)
    assert_response :success
    assert_select "#stats_field_kit_item_#{item.id}"
    assert_select "#new_sighting form"
    assert_select "#sightings_field_kit_item_#{item.id} turbo-frame#sighting_#{sightings(:robin).id}"
    assert_match "American Robin", response.body
  end

  test "create adds a lens to the kit and responds with turbo streams" do
    lens = lenses(:ultima)
    assert_difference "FieldKitItem.count", 1 do
      post field_kit_items_path(lens_id: lens.id), headers: TURBO_STREAM_HEADERS
    end
    assert_response :success
    assert_equal "text/vnd.turbo-stream.html", response.media_type
    assert_match "<turbo-stream", response.body
    assert_match "kit_lens_#{lens.id}", response.body
    assert_match "popularity_lens_#{lens.id}", response.body
    assert_match "field_kit_items_count", response.body
    assert_equal 1, lens.reload.field_kit_items_count
  end

  test "destroy removes a lens from the kit and responds with turbo streams" do
    item = field_kit_items(:ian_monarch)
    assert_difference "FieldKitItem.count", -1 do
      delete field_kit_item_path(item), headers: TURBO_STREAM_HEADERS
    end
    assert_response :success
    assert_match "<turbo-stream", response.body
    assert_match "remove", response.body
    assert_equal 0, lenses(:monarch).reload.field_kit_items_count
  end

  test "empty page renders when the kit is empty" do
    FieldKitItem.delete_all
    Sighting.delete_all
    get field_kit_items_path
    assert_response :success
    assert_match "Your field kit is empty", response.body
  end

  test "requires signin" do
    delete session_path
    get field_kit_items_path
    assert_redirected_to signin_path
  end
end
