class RemoveDefaultPenalty < ActiveRecord::Migration
  def change
    change_column :races, :penalty, :float
  end
end
