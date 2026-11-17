# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2026_11_17_232134) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "field_kit_items", force: :cascade do |t|
    t.bigint "lens_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lens_id"], name: "index_field_kit_items_on_lens_id"
    t.index ["user_id"], name: "index_field_kit_items_on_user_id"
  end

  create_table "lenses", force: :cascade do |t|
    t.string "name"
    t.string "category"
    t.text "description"
    t.string "image"
    t.integer "field_kit_items_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sightings", force: :cascade do |t|
    t.string "species"
    t.decimal "weight"
    t.decimal "length"
    t.integer "likes_count", default: 0
    t.bigint "lens_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lens_id"], name: "index_sightings_on_lens_id"
    t.index ["user_id"], name: "index_sightings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "field_kit_items", "lenses"
  add_foreign_key "field_kit_items", "users"
  add_foreign_key "sightings", "lenses"
  add_foreign_key "sightings", "users"
end
