class CreateResults < ActiveRecord::Migration
  def self.up
    create_table :results do |t|
      t.integer :competitor_id
      t.integer :rank
      t.float :fis_points
      t.float :cup_points
      t.string :href
      t.timestamps
    end
  end

  def self.down
    drop_table :results
  end
end
