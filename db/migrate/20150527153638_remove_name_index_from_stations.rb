class RemoveNameIndexFromStations < ActiveRecord::Migration
  def change
    remove_index :stations, column: :name, unique: true
  end
end
