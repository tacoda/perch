class AddFieldKitItemsCountToLenses < ActiveRecord::Migration[8.0]
  def up
    add_column :lenses, :field_kit_items_count, :integer, default: 0, null: false

    Lens.reset_column_information
    Lens.find_each do |lens|
      Lens.reset_counters(lens.id, :field_kit_items)
    end
  end

  def down
    remove_column :lenses, :field_kit_items_count
  end
end
