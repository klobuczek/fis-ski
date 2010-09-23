class Collapsed2 < ActiveRecord::Migration
  def self.up
    create_table "competitors", :force => true do |t|
      t.string "gender", :limit => 1
      t.integer "fis_code", :null => false
      t.string "name"
      t.string "href"
      t.integer "year"
      t.string "nation", :limit => 3
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "competitors", ["fis_code"], :name => "index_competitors_on_fis_code"
    add_index "competitors", ["gender", "year"], :name => "index_competitors_on_gender_and_year"

    create_table "races", :force => true do |t|
      t.integer "codex", :null => false
      t.integer "season", :null => false
      t.string "place", :null => false
      t.string "nation", :null => false
      t.string "discipline"
      t.string "href"
      t.string "gender", :limit => 1, :null => false
      t.integer "factor", :default => 1, :null => false
      t.string "source"
      t.date "date", :null => false
      t.string "comments"
      t.string "status"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string "race_category", :limit => 1
      t.datetime "loaded_at"
    end

    add_index "races", ["codex"], :name => "index_races_on_codex"

    create_table "results", :force => true do |t|
      t.integer "competitor_id", :null => false
      t.integer "race_id", :null => false
      t.integer "rank"
      t.float "fis_points", :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer "overall_rank", :null => false
    end

    add_index "results", ["competitor_id"], :name => "index_results_on_competitor_id"
    add_index "results", ["race_id"], :name => "index_results_on_race_id"

    create_table "users", :force => true do |t|
      t.string "email", :default => "", :null => false
      t.string "encrypted_password", :limit => 128, :default => "", :null => false
      t.string "password_salt", :default => "", :null => false
      t.string "confirmation_token"
      t.datetime "confirmed_at"
      t.datetime "confirmation_sent_at"
      t.string "reset_password_token"
      t.string "remember_token"
      t.datetime "remember_created_at"
      t.integer "sign_in_count", :default => 0
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.string "current_sign_in_ip"
      t.string "last_sign_in_ip"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
    add_index "users", ["email"], :name => "index_users_on_email", :unique => true
    add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

    add_foreign_key :results, :competitor_id, :competitors
    add_foreign_key :results, :race_id, :races

  end

  def self.down
  end
end
