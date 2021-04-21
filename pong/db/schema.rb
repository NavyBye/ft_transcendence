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

ActiveRecord::Schema.define(version: 2021_04_19_051209) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "blocks", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "blocked_user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["blocked_user_id"], name: "index_blocks_on_blocked_user_id"
    t.index ["user_id", "blocked_user_id"], name: "index_blocks_on_user_id_and_blocked_user_id", unique: true
    t.index ["user_id"], name: "index_blocks_on_user_id"
  end

  create_table "chat_room_messages", force: :cascade do |t|
    t.bigint "chat_room_id", null: false
    t.bigint "user_id", null: false
    t.string "body"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["chat_room_id"], name: "index_chat_room_messages_on_chat_room_id"
    t.index ["user_id"], name: "index_chat_room_messages_on_user_id"
  end

  create_table "chat_rooms", force: :cascade do |t|
    t.string "name"
    t.string "encrypted_password"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_chat_rooms_on_name", unique: true
  end

  create_table "chat_rooms_members", force: :cascade do |t|
    t.bigint "chat_room_id", null: false
    t.bigint "user_id", null: false
    t.integer "role", default: 0
    t.integer "status", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["chat_room_id"], name: "index_chat_rooms_members_on_chat_room_id"
    t.index ["user_id"], name: "index_chat_rooms_members_on_user_id"
  end

  create_table "friends", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "follow_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["follow_id"], name: "index_friends_on_follow_id"
    t.index ["user_id", "follow_id"], name: "index_friends_on_user_id_and_follow_id", unique: true
    t.index ["user_id"], name: "index_friends_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.string "provider"
    t.string "uid"
    t.string "nickname", default: "newcomer"
    t.integer "status", default: 0
    t.integer "rating", default: 1500
    t.integer "rank"
    t.integer "trophy", default: 0
    t.boolean "is_banned", default: false
    t.boolean "is_email_auth", default: false
    t.string "image"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["name"], name: "index_users_on_name", unique: true
    t.index ["provider"], name: "index_users_on_provider"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid"], name: "index_users_on_uid"
  end

  add_foreign_key "blocks", "users"
  add_foreign_key "blocks", "users", column: "blocked_user_id"
  add_foreign_key "chat_room_messages", "chat_rooms", on_delete: :cascade
  add_foreign_key "chat_room_messages", "users", on_delete: :cascade
  add_foreign_key "chat_rooms_members", "chat_rooms", on_delete: :cascade
  add_foreign_key "chat_rooms_members", "users", on_delete: :cascade
  add_foreign_key "friends", "users"
  add_foreign_key "friends", "users", column: "follow_id"
end
