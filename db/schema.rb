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

ActiveRecord::Schema[8.0].define(version: 2025_05_24_114148) do
  create_table "cities", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.index ["name"], name: "index_cities_on_name"
    t.index ["slug"], name: "index_cities_on_slug"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "geos", force: :cascade do |t|
    t.integer "lat"
    t.integer "long"
    t.string "street_address"
    t.index ["street_address"], name: "index_geos_on_street_address"
  end

  create_table "greenspaces", force: :cascade do |t|
    t.string "name"
    t.integer "city_id"
    t.integer "address_id"
    t.string "slug", null: false
    t.index ["address_id"], name: "index_greenspaces_on_address_id"
    t.index ["city_id"], name: "index_greenspaces_on_city_id"
    t.index ["name"], name: "index_greenspaces_on_name"
    t.index ["slug"], name: "index_greenspaces_on_slug"
  end

  create_table "hikes", force: :cascade do |t|
    t.date "date"
    t.integer "greenspace_id", null: false
    t.integer "distance"
    t.integer "waste"
    t.index ["date"], name: "index_hikes_on_date"
    t.index ["greenspace_id"], name: "index_hikes_on_greenspace_id"
  end

  create_table "links", force: :cascade do |t|
    t.string "ownable_type", null: false
    t.integer "ownable_id", null: false
    t.string "kind"
    t.string "uri"
    t.index ["ownable_type", "ownable_id"], name: "index_links_on_ownable"
  end

  create_table "pages", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.index ["name"], name: "index_pages_on_name"
    t.index ["slug"], name: "index_pages_on_slug"
  end

  add_foreign_key "greenspaces", "geos", column: "address_id"
  add_foreign_key "hikes", "greenspaces"
end
