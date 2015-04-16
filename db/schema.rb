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

ActiveRecord::Schema.define(version: 20150416063402) do

  create_table "events", force: :cascade do |t|
    t.string   "organization"
    t.string   "name"
    t.string   "location"
    t.string   "description"
    t.datetime "start"
    t.string   "meetup_id"
    t.integer  "duration"
    t.datetime "updated"
    t.string   "url"
    t.string   "how_to_find_us"
    t.string   "status"
    t.string   "address_1"
    t.string   "city"
    t.string   "zip"
    t.string   "state"
    t.string   "country"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "guests", force: :cascade do |t|
    t.string  "first_name"
    t.string  "last_name"
    t.string  "phone"
    t.string  "email"
    t.string  "address"
    t.boolean "is_anon"
    t.string  "meetup_id"
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
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "expires_at"
    t.string   "refresh_token"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
