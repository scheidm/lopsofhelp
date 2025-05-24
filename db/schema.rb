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

ActiveRecord::Schema[8.0].define(version: 2025_05_24_185146) do
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
    t.string "lat"
    t.string "lon"
    t.string "street_address"
    t.integer "greenspace_id"
    t.index ["greenspace_id"], name: "index_geos_on_greenspace_id"
    t.index ["street_address"], name: "index_geos_on_street_address"
  end

  create_table "greenspaces", force: :cascade do |t|
    t.string "name"
    t.integer "city_id"
    t.string "slug", null: false
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

  create_table "taggings", force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at", precision: nil
    t.string "tenant", limit: 128
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable_type_and_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
    t.index ["tagger_type", "tagger_id"], name: "index_taggings_on_tagger_type_and_tagger_id"
    t.index ["tenant"], name: "index_taggings_on_tenant"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  add_foreign_key "hikes", "greenspaces"
  add_foreign_key "taggings", "tags"
end
