class RemoveRanks < ActiveRecord::Migration
  def change
    remove_columns :results, :rank, :overall_rank
  end
end
