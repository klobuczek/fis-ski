class CreatePenalties < ActiveRecord::Migration
  def change
    create_table :penalties do |t|
      t.string :category, limit: 3, null: false
      t.integer :min, null: false
      t.integer :max, null: false

      t.timestamps null: false
    end
  end
end
