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

ActiveRecord::Schema[7.2].define(version: 2024_11_09_031516) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "business_hours", force: :cascade do |t|
    t.integer "day_of_week", null: false
    t.integer "status", default: 0, null: false
    t.time "open_time"
    t.time "close_time"
    t.integer "take_away_store_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["take_away_store_id"], name: "index_business_hours_on_take_away_store_id"
  end

  create_table "characteristics", force: :cascade do |t|
    t.string "quality_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "take_away_store_id", null: false
    t.index ["take_away_store_id"], name: "index_characteristics_on_take_away_store_id"
  end

  create_table "historics", force: :cascade do |t|
    t.integer "item_id", null: false
    t.integer "portion_id", null: false
    t.string "description_portion"
    t.string "price_portion"
    t.date "upload_date"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_historics_on_item_id"
    t.index ["portion_id"], name: "index_historics_on_portion_id"
  end

  create_table "item_menus", force: :cascade do |t|
    t.integer "item_id", null: false
    t.integer "menu_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_item_menus_on_item_id"
    t.index ["menu_id"], name: "index_item_menus_on_menu_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "calories"
    t.integer "take_away_store_id", null: false
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0, null: false
    t.index ["take_away_store_id"], name: "index_items_on_take_away_store_id"
  end

  create_table "menus", force: :cascade do |t|
    t.string "name", null: false
    t.integer "take_away_store_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["take_away_store_id"], name: "index_menus_on_take_away_store_id"
  end

  create_table "owners", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "register_number", null: false
    t.string "name", null: false
    t.string "surname", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_owners_on_email", unique: true
    t.index ["reset_password_token"], name: "index_owners_on_reset_password_token", unique: true
  end

  create_table "portions", force: :cascade do |t|
    t.string "option_name", limit: 16, null: false
    t.integer "value", null: false
    t.integer "item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_portions_on_item_id"
  end

  create_table "tags", force: :cascade do |t|
    t.integer "item_id", null: false
    t.integer "characteristic_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["characteristic_id"], name: "index_tags_on_characteristic_id"
    t.index ["item_id"], name: "index_tags_on_item_id"
  end

  create_table "take_away_stores", force: :cascade do |t|
    t.string "trade_name", null: false
    t.string "corporate_name", null: false
    t.string "register_number", null: false
    t.string "street", null: false
    t.string "number", null: false
    t.string "district", null: false
    t.string "city", null: false
    t.string "state", null: false
    t.string "zip_code", null: false
    t.string "complement"
    t.string "phone_number", null: false
    t.string "email", null: false
    t.string "code", null: false
    t.integer "owner_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_take_away_stores_on_owner_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "business_hours", "take_away_stores"
  add_foreign_key "characteristics", "take_away_stores"
  add_foreign_key "historics", "items"
  add_foreign_key "historics", "portions"
  add_foreign_key "item_menus", "items"
  add_foreign_key "item_menus", "menus"
  add_foreign_key "items", "take_away_stores"
  add_foreign_key "menus", "take_away_stores"
  add_foreign_key "portions", "items"
  add_foreign_key "tags", "characteristics"
  add_foreign_key "tags", "items"
  add_foreign_key "take_away_stores", "owners"
end
