require "test_helper"

class LensesTest < ActionDispatch::IntegrationTest
  test "index lists lenses inside a turbo frame" do
    get lenses_path
    assert_response :success
    assert_select "turbo-frame#lenses"
    assert_select ".lens", count: 2
  end

  test "index filters by query inside the frame" do
    get lenses_path, params: { query: "monarch" }
    assert_response :success
    assert_select ".lens", count: 1
    assert_match "Nikon Monarch", response.body
    assert_no_match "Celestron", response.body
  end

  test "index filters by category" do
    get lenses_path, params: { category: "Scope" }
    assert_response :success
    assert_select ".lens", count: 1
    assert_match "Celestron", response.body
  end

  test "show renders top sightings ordered by likes" do
    get lens_path(lenses(:ultima))
    assert_response :success
    assert_select "table.top-sightings"
    assert_match "Great Blue Heron", response.body
    assert_match "Bald Eagle", response.body
  end

  test "signed in users see add/remove field kit buttons" do
    sign_in_as users(:ian)
    get lenses_path
    assert_response :success
    assert_select "#kit_lens_#{lenses(:monarch).id} form[action='#{field_kit_item_path(field_kit_items(:ian_monarch))}']"
    assert_select "#kit_lens_#{lenses(:ultima).id} form[action='#{field_kit_items_path(lens_id: lenses(:ultima).id)}']"
  end
end
