require "test_helper"

class ActivityTest < ActionDispatch::IntegrationTest
  test "index subscribes to the activity stream and lists recent sightings" do
    get activity_path
    assert_response :success
    assert_select "turbo-cable-stream-source"
    assert_select "#sightings .sighting", count: 3
    assert_match "American Robin", response.body
    assert_match "Great Blue Heron", response.body
    assert_match "like_sighting_#{sightings(:heron).id}", response.body
  end
end
