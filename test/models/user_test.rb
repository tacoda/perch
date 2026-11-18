require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "field_kit_item_for_most_recent_sighting returns the kit item for the lens of the latest sighting" do
    user = users(:ian)
    assert_equal field_kit_items(:ian_monarch), user.field_kit_item_for_most_recent_sighting
  end

  test "field_kit_item_for_most_recent_sighting is nil without sightings" do
    user = User.create!(username: "Newbie", password: "secret")
    assert_nil user.field_kit_item_for_most_recent_sighting
  end

  test "username must be present and unique" do
    assert_not User.new(password: "secret").valid?
    assert_not User.new(username: "ian", password: "secret").valid?
    assert User.new(username: "Unique", password: "secret").valid?
  end
end
