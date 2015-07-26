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

ActiveRecord::Schema.define(version: 20150723062030) do

  create_table "competitors", force: :cascade do |t|
    t.string   "gender",     limit: 1
    t.integer  "fis_code",   limit: 4,   null: false
    t.string   "name",       limit: 255
    t.string   "href",       limit: 255
    t.integer  "year",       limit: 4
    t.string   "nation",     limit: 3
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "competitors", ["fis_code"], name: "index_competitors_on_fis_code", using: :btree
  add_index "competitors", ["gender", "year"], name: "index_competitors_on_gender_and_year", using: :btree

  create_table "penalties", force: :cascade do |t|
    t.string   "category",   limit: 3, null: false
    t.integer  "min",        limit: 4, null: false
    t.integer  "max",        limit: 4, null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "races", force: :cascade do |t|
    t.integer  "codex",      limit: 4,                 null: false
    t.integer  "season",     limit: 4,                 null: false
    t.string   "place",      limit: 255,               null: false
    t.string   "nation",     limit: 255,               null: false
    t.string   "discipline", limit: 255
    t.string   "href",       limit: 255
    t.string   "gender",     limit: 1,                 null: false
    t.integer  "factor",     limit: 4,   default: 1,   null: false
    t.date     "date",                                 null: false
    t.string   "comments",   limit: 255
    t.string   "status",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "age_group",  limit: 1
    t.datetime "loaded_at"
    t.string   "category",   limit: 3,                 null: false
    t.float    "penalty",    limit: 24,  default: 0.0
  end

  add_index "races", ["codex"], name: "index_races_on_codex", using: :btree

  create_table "results", force: :cascade do |t|
    t.integer  "competitor_id", limit: 4,  null: false
    t.integer  "race_id",       limit: 4,  null: false
    t.float    "race_points",   limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "failure",       limit: 3
    t.float    "time",          limit: 24
  end

  add_index "results", ["competitor_id"], name: "index_results_on_competitor_id", using: :btree
  add_index "results", ["race_id"], name: "index_results_on_race_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                limit: 255, default: "", null: false
    t.string   "encrypted_password",   limit: 128, default: "", null: false
    t.string   "password_salt",        limit: 255, default: "", null: false
    t.string   "confirmation_token",   limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "reset_password_token", limit: 255
    t.string   "remember_token",       limit: 255
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",        limit: 4,   default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",   limit: 255
    t.string   "last_sign_in_ip",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "results", "competitors"
  add_foreign_key "results", "races"
end
