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

ActiveRecord::Schema.define(version: 20150404203202) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "pictures", force: true do |t|
    t.string   "title"
    t.integer  "position"
    t.boolean  "display",            default: true, null: false
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "pictures", ["imageable_id", "imageable_type"], name: "index_pictures_on_imageable_id_and_imageable_type", using: :btree
  add_index "pictures", ["imageable_type"], name: "index_pictures_on_imageable_type", using: :btree

  create_table "projects", force: true do |t|
    t.string   "title"
    t.string   "url"
    t.text     "description"
    t.integer  "ord"
    t.boolean  "display",     default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "source_url"
  end

  create_table "users", force: true do |t|
    t.string   "email",                                                         null: false
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "is_admin",               default: false,                        null: false
    t.string   "password_digest",                                               null: false
    t.string   "session_token",                                                 null: false
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.boolean  "is_active",              default: false,                        null: false
    t.string   "activation_token",       default: "INACTIVE",                   null: false
    t.string   "uid"
    t.string   "access_token"
    t.string   "provider"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.string   "fb_image_url"
    t.boolean  "display",                default: true,                         null: false
    t.integer  "position"
    t.string   "title"
    t.string   "string"
    t.text     "bio"
    t.string   "phone"
    t.string   "work_phone"
    t.string   "home_phone"
    t.string   "mobile_phone"
    t.string   "fax"
    t.string   "timezone",               default: "Eastern Time (US & Canada)", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_index "users", ["display"], name: "index_users_on_display", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
