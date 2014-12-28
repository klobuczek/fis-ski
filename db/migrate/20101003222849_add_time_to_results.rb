class AddTimeToResults < ActiveRecord::Migration
  def self.up
    add_column :results, :time, :float
  end

  def self.down
    remove_column :results, :time
  end
end
