class AddFailureToResults < ActiveRecord::Migration
  def self.up
    add_column :results, :failure, :string, :limit => 3
    remove_column :races, :source
    change_column :results, :overall_rank, :integer, :null => true
  end

  def self.down
    remove_column :results, :failure
    add_column :races, :source, :string
    change_column :results, :overall_rank, :integer, :null => false
  end
end
