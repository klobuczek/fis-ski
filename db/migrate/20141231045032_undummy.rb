class Undummy < ActiveRecord::Migration
  def change
    drop_table :dummy
  end
end
