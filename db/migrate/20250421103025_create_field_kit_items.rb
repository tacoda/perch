class CreateFieldKitItems < ActiveRecord::Migration[8.0]
  def change
    create_table :field_kit_items do |t|
      t.references :lens, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
