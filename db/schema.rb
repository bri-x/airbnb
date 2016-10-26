# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161024073639) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authentications", force: :cascade do |t|
    t.string   "uid"
    t.string   "token"
    t.string   "provider"
    t.string   "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cities", force: :cascade do |t|
    t.string   "name"
    t.string   "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "listings", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "property_type"
    t.string   "room_type"
    t.integer  "capacity"
    t.integer  "price"
    t.integer  "min_stay"
    t.string   "address"
    t.integer  "user_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "city_id"
    t.json     "photos"
    t.date     "unavailable_dates", default: [],              array: true
  end

  add_index "listings", ["city_id"], name: "index_listings_on_city_id", using: :btree
  add_index "listings", ["user_id"], name: "index_listings_on_user_id", using: :btree

  create_table "payments", force: :cascade do |t|
    t.integer  "reservation_id"
    t.string   "braintree_payment_id"
    t.string   "status"
    t.string   "fourdigit"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "payments", ["reservation_id"], name: "index_payments_on_reservation_id", using: :btree

  create_table "reservations", force: :cascade do |t|
    t.date     "date_start"
    t.date     "date_end"
    t.integer  "amount"
    t.integer  "total_price"
    t.integer  "listing_id"
    t.integer  "user_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "paid",        default: false
  end

  add_index "reservations", ["listing_id"], name: "index_reservations_on_listing_id", using: :btree
  add_index "reservations", ["user_id"], name: "index_reservations_on_user_id", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "listing_id"
    t.string   "context"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "taggings", ["listing_id"], name: "index_taggings_on_listing_id", using: :btree
  add_index "taggings", ["tag_id", "context"], name: "index_taggings_on_tag_id_and_context", using: :btree
  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.integer  "count",      default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "encrypted_password", limit: 128
    t.string   "confirmation_token", limit: 128
    t.string   "remember_token",     limit: 128
    t.string   "avatar"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

  create_table "validities", force: :cascade do |t|
    t.integer  "listing_id"
    t.date     "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "validities", ["date", "listing_id"], name: "index_validities_on_date_and_listing_id", unique: true, using: :btree

  add_foreign_key "listings", "cities"
  add_foreign_key "listings", "users"
  add_foreign_key "payments", "reservations"
  add_foreign_key "reservations", "listings"
  add_foreign_key "reservations", "users"
  add_foreign_key "taggings", "listings"
  add_foreign_key "taggings", "tags"
end
