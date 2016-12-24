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

ActiveRecord::Schema.define(version: 20161223105305) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "friend_invitations", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "author_id",    null: false
    t.uuid     "recipient_id", null: false
    t.datetime "accepted_at"
    t.datetime "rejected_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["author_id", "recipient_id"], name: "index_friend_invitations_on_author_id_and_recipient_id", unique: true, using: :btree
  end

  create_table "users", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "name"
    t.string   "display_name"
    t.string   "email"
    t.boolean  "terms_accepted",    default: false
    t.string   "role",              default: "user"
    t.datetime "blocked_at"
    t.datetime "deleted_at"
    t.string   "auth_token"
    t.datetime "token_expire_time"
    t.string   "password_digest"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["name"], name: "index_users_on_name", unique: true, using: :btree
  end

  create_table "users_users", force: :cascade do |t|
    t.uuid     "user_id",    null: false
    t.uuid     "friend_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["friend_id"], name: "index_users_users_on_friend_id", using: :btree
    t.index ["user_id"], name: "index_users_users_on_user_id", using: :btree
  end

end
