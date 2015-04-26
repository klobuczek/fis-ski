class AddPenaltyToRaces < ActiveRecord::Migration
  def change
    add_column :races, :penalty, :float, default: 0
  end
end
