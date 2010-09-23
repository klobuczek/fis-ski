class MakeFisPointsNullable < ActiveRecord::Migration
  def self.up
    change_column :results, :fis_points, :float, :null => true
  end

  def self.down
    change_column :results, :fis_points, :float, :null => false
  end
end
