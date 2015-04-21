class ChangeNameOnStations < ActiveRecord::Migration
  def change
    change_column :stations, :name, :string, null: false
  end
end
