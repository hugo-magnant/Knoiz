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

ActiveRecord::Schema[7.0].define(version: 2023_02_28_155943) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "profiles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
    t.datetime "timestamp"
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "spotifydata", force: :cascade do |t|
    t.jsonb "favorite_genre", default: [["Genre 1", 5], ["Genre 2", 4], ["Genre 3", 3], ["Genre 4", 2], ["Genre 5", 1]]
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.datetime "timestamp", precision: nil, default: -> { "CURRENT_TIMESTAMP" }
    t.index ["user_id"], name: "index_spotifydata_on_user_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string "stripe_user_id"
    t.boolean "active", default: false, null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "stripe_subscription_id"
    t.boolean "canceled", default: false
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "spotify_id"
    t.string "username"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wallets", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "timestamp", precision: nil, default: "2022-12-31 23:00:00"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_wallets_on_user_id"
  end

  add_foreign_key "profiles", "users"
  add_foreign_key "spotifydata", "users"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "wallets", "users"
end
