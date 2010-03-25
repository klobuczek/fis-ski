class AddRaceCategory < ActiveRecord::Migration
  def self.up
    add_column :races, :race_category, :string, :limit => 1
    add_column :races, :loaded_at, :datetime
    Race.update_all("loaded_at=now()", "status = 'loaded'")
    add_race_category
  end

  def self.down
    remove_column :races, :race_category
    remove_column :races, :loaded_at
  end

  def self.add_race_category
     Race.all(:conditions => {:status => 'loaded'}).each do |r|
       r.update_attribute(:race_category, Category.new(:season => r.season, :year => r.results.first.competitor.year).race_category(r.gender))
     end
  end
end
