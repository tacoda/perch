class CreateSightings < ActiveRecord::Migration[8.0]
  def change
    create_table :sightings do |t|
      t.string  :species
      t.decimal :weight
      t.decimal :length
      t.integer :likes_count, default: 0

      t.references :lens, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
