class CreateCompetitors < ActiveRecord::Migration
  def self.up
    create_table :competitors do |t|
      t.string :gender, :limit => 1
      t.integer :category
      t.integer :fis_code
      t.string :name
      t.string :href
      t.integer :year
      t.string :nation, :limit => 3
      t.timestamps
    end
    add_index :competitors, :fis_code
    add_index :competitors, [:gender, :category]
  end

  def self.down
    drop_table :competitors
  end
end
