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

ActiveRecord::Schema.define(version: 20180411160615) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "expired_tokens", force: :cascade do |t|
    t.string "token", null: false
    t.datetime "expires_at", null: false
    t.index ["token"], name: "index_expired_tokens_on_token", unique: true
  end

  create_table "households", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inmates", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "household_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_admin", default: false
    t.index ["household_id"], name: "index_inmates_on_household_id"
    t.index ["user_id", "household_id"], name: "index_inmates_on_user_id_and_household_id", unique: true
    t.index ["user_id"], name: "index_inmates_on_user_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.string "type", null: false
    t.string "title", null: false
    t.text "description"
    t.decimal "amount", precision: 12, scale: 2, null: false
    t.integer "user_id", null: false
    t.integer "household_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["household_id"], name: "index_transactions_on_household_id"
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", default: "", null: false
    t.string "password_digest", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "inmates", "households"
  add_foreign_key "inmates", "users"
end
