class Collapsed < ActiveRecord::Migration
  def self.up
    create_table "competitors", :force => true do |t|
      t.string   "gender", :limit => 1
      t.integer  "fis_code", :null => false
      t.string   "name"
      t.string   "href"
      t.integer  "year"
      t.string   "nation", :limit => 3
      t.timestamps
    end

    add_index "competitors", ["fis_code"]
    add_index "competitors", ["gender", "year"]

    create_table "races", :force => true do |t|
      t.integer  "codex", :null => false
      t.integer  "season", :null => false
      t.string   "place", :null => false
      t.string   "nation", :null => false
      t.string   "discipline"
      t.string   "href"
      t.string   "gender", :limit => 1, :null => false
      t.integer  "factor", :default => 1, :null => false
      t.string   "source"
      t.date     :date, :null => false
      t.string     :comments
      t.string     :status
      t.timestamps
    end

    add_index "races", ["codex"]

    create_table "results", :force => true do |t|
      t.references  :competitor, :null => false
      t.references  :race, :null => false
      t.integer  "rank"
      t.float    "fis_points", :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "overall_rank", :null => false
    end

    add_index "results", ["competitor_id"]
    add_index "results", ["race_id"]

    add_foreign_key :results, :competitor_id, :competitors
    add_foreign_key :results, :race_id, :races

  end

  def self.down
  end
end
