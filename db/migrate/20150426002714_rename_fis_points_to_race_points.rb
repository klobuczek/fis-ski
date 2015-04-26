class RenameFisPointsToRacePoints < ActiveRecord::Migration
  def change
    rename_column :results, :fis_points, :race_points
  end
end
