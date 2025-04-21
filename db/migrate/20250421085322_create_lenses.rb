class CreateLenses < ActiveRecord::Migration[8.0]
  def change
    create_table :lenses do |t|
      t.string  :name
      t.string  :category
      t.text    :description
      t.string  :image
      t.integer :field_kit_items_count, default: 0

      t.timestamps
    end

    add_index :lenses, :name, unique: true
  end
end
