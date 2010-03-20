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

ActiveRecord::Schema.define(:version => 20100313224754) do

  create_table "competitors", :force => true do |t|
    t.string   "gender",     :limit => 1
    t.integer  "fis_code",                :null => false
    t.string   "name"
    t.string   "href"
    t.integer  "year"
    t.string   "nation",     :limit => 3
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "competitors", ["fis_code"], :name => "index_competitors_on_fis_code"
  add_index "competitors", ["gender", "year"], :name => "index_competitors_on_gender_and_year"

  create_table "races", :force => true do |t|
    t.integer  "codex",                                  :null => false
    t.integer  "season",                                 :null => false
    t.string   "place",                                  :null => false
    t.string   "nation",                                 :null => false
    t.string   "discipline"
    t.string   "href"
    t.string   "gender",     :limit => 1,                :null => false
    t.integer  "factor",                  :default => 1, :null => false
    t.string   "source"
    t.date     "date",                                   :null => false
    t.string   "comments"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "races", ["codex"], :name => "index_races_on_codex"

  create_table "results", :force => true do |t|
    t.integer  "competitor_id", :null => false
    t.integer  "race_id",       :null => false
    t.integer  "rank"
    t.float    "fis_points",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "overall_rank",  :null => false
  end

  add_index "results", ["competitor_id"], :name => "index_results_on_competitor_id"
  add_index "results", ["race_id"], :name => "index_results_on_race_id"

end
