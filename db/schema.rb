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

ActiveRecord::Schema.define(version: 20141213125708) do

  create_table "app_notifications", force: true do |t|
    t.string   "class_name"
    t.string   "method_name"
    t.string   "values"
    t.boolean  "is_viewed",   default: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "app_notifications", ["user_id"], name: "index_app_notifications_on_user_id", using: :btree

  create_table "images", force: true do |t|
    t.float    "latitude",   limit: 24
    t.float    "longitude",  limit: 24
    t.boolean  "validate",              default: false
    t.text     "comment"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "images_tags", force: true do |t|
    t.integer "image_id"
    t.integer "tag_id"
  end

  create_table "tags", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "tags_users", force: true do |t|
    t.integer "user_id"
    t.integer "tag_id"
  end

  create_table "users", force: true do |t|
    t.string   "email",                             default: "",  null: false
    t.string   "encrypted_password",                default: "",  null: false
    t.string   "name"
    t.integer  "points",                            default: 15
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0,   null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "quality_rate",           limit: 24, default: 1.0
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "votes", force: true do |t|
    t.float    "latitude",   limit: 24
    t.float    "longitude",  limit: 24
    t.string   "validate",              default: "pending"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "image_id"
  end

end
