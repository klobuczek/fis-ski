# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100225101659) do

  create_table "competitors", :force => true do |t|
    t.integer  "fis_code"
    t.string   "name"
    t.string   "href"
    t.integer  "year"
    t.string   "nation",     :limit => 3
    t.string   "gender",     :limit => 1
    t.integer  "category"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "competitors", ["fis_code"], :name => "index_competitors_on_fis_code"
  add_index "competitors", ["gender", "category"], :name => "index_competitors_on_gender_and_category"

  create_table "results", :force => true do |t|
    t.integer  "competitor_id"
    t.integer  "rank"
    t.float    "fis_points"
    t.float    "cup_points"
    t.string   "href"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
