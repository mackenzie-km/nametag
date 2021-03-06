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

ActiveRecord::Schema.define(version: 2019_09_24_230947) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contacts", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "gender"
    t.integer "user_id"
    t.string "phone_number"
    t.string "school_status"
    t.string "messenger_id"
    t.date "last_day"
    t.string "major"
    t.string "country"
    t.date "birthday"
    t.integer "admin_level"
    t.boolean "newsletter", default: false
    t.boolean "unsubscribed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "source"
  end

  create_table "contacts_events", force: :cascade do |t|
    t.bigint "contact_id", null: false
    t.bigint "event_id", null: false
    t.index ["contact_id"], name: "index_contacts_events_on_contact_id"
    t.index ["event_id"], name: "index_contacts_events_on_event_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.date "date"
    t.integer "admin_level"
    t.integer "staff_count", default: 0
    t.integer "guest_count", default: 0
    t.datetime "created_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.integer "admin_level", default: 0
    t.string "google_token"
    t.string "google_refresh_token"
  end

end
