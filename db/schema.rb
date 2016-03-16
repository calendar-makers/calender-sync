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

ActiveRecord::Schema.define(version: 20150503225024) do

  create_table "events", force: :cascade do |t|
    t.string   "organization"
    t.string   "name"
    t.string   "description"
    t.datetime "start"
    t.string   "meetup_id"
    t.datetime "updated"
    t.string   "url"
    t.string   "how_to_find_us"
    t.string   "status"
    t.string   "city"
    t.string   "zip"
    t.string   "state"
    t.string   "country"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "venue_name"
    t.datetime "end"
    t.string   "st_number"
    t.string   "st_name"
  end

  create_table "guests", force: :cascade do |t|
    t.string  "first_name"
    t.string  "last_name"
    t.string  "phone"
    t.string  "email"
    t.string  "address"
    t.boolean "is_anon"
    t.string  "meetup_id"
    t.string  "city"
    t.string  "state"
    t.string  "zip"
  end

  create_table "registrations", force: :cascade do |t|
    t.integer  "event_id"
    t.integer  "guest_id"
    t.integer  "invited_guests"
    t.datetime "updated"
  end

  add_index "registrations", ["event_id"], name: "index_registrations_on_event_id"
  add_index "registrations", ["guest_id"], name: "index_registrations_on_guest_id"

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "failed_attempts",        default: 0,  null: false
<<<<<<< HEAD
    t.integer  "level",                  default: 0,  null: false
=======
    t.string   "unlock_token"
>>>>>>> 0766616fe615fe75c50d4904a3c370a42880e411
    t.datetime "locked_at"
    t.integer  "level",                  default: 1
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
