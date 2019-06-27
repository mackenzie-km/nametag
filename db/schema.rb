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

ActiveRecord::Schema.define(version: 2019_06_27_184458) do

  create_table "contacts", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.integer "gender"
    t.integer "user_id"
    t.integer "phone_number"
    t.string "school_status"
    t.string "messenger_company"
    t.string "messenger_id"
    t.string "major"
    t.string "country"
    t.date "birthday"
  end

  create_table "contacts_events", id: false, force: :cascade do |t|
    t.integer "contact_id", null: false
    t.integer "event_id", null: false
    t.integer "guests"
    t.index ["contact_id", "event_id"], name: "index_contacts_events_on_contact_id_and_event_id"
    t.index ["event_id", "contact_id"], name: "index_contacts_events_on_event_id_and_contact_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.date "date"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "admin_level"
  end

end
