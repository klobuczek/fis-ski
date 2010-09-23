class RenameTerms < ActiveRecord::Migration
  def self.up
    rename_column :races, :race_category, :age_group
    add_column :races, :category, :string, :limit => 3, :null => false
  end

  def self.down
    rename_column :races, :age_group, :race_category
    remove_column :races, :category
  end
end
