class AddCharacterSetToStations < ActiveRecord::Migration
  def change
    add_column :stations, :character_set, :integer, null: false, default: 0
  end
end
