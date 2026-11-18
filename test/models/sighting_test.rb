require "test_helper"

class SightingTest < ActiveSupport::TestCase
  test "requires a species" do
    sighting = Sighting.new(lens: lenses(:monarch), user: users(:ian))
    assert_not sighting.valid?
    assert_includes sighting.errors[:species], "can't be blank"
  end

  test "weight and length must be positive when present but may be blank" do
    sighting = Sighting.new(species: "Robin", weight: -1, lens: lenses(:monarch), user: users(:ian))
    assert_not sighting.valid?

    sighting.weight = nil
    sighting.length = 0.5
    assert sighting.valid?
  end
end
