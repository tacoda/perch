require "test_helper"

class LensTest < ActiveSupport::TestCase
  test "field_kit_items_count counter cache tracks kit items" do
    lens = lenses(:ultima)
    assert_equal 0, lens.field_kit_items_count

    item = FieldKitItem.create!(user: users(:ian), lens: lens)
    assert_equal 1, lens.reload.field_kit_items_count

    item.destroy
    assert_equal 0, lens.reload.field_kit_items_count
  end
end
