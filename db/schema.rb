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

ActiveRecord::Schema.define(version: 2019_02_23_230113) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.integer "time"
    t.text "content"
    t.bigint "viewing_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_comments_on_user_id"
    t.index ["viewing_id"], name: "index_comments_on_viewing_id"
  end

  create_table "joinings", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "viewing_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_joinings_on_user_id"
    t.index ["viewing_id"], name: "index_joinings_on_viewing_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_rooms_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "display_name"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_users_on_name", unique: true
  end

  create_table "videos", force: :cascade do |t|
    t.string "netflix_id"
    t.integer "runtime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
  end

  create_table "viewings", force: :cascade do |t|
    t.integer "start_time"
    t.datetime "started_at"
    t.boolean "active"
    t.bigint "room_id"
    t.bigint "video_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_viewings_on_room_id"
    t.index ["video_id"], name: "index_viewings_on_video_id"
  end

end
