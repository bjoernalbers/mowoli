class ChangeAetitleOnStations < ActiveRecord::Migration
  def change
    change_column :stations, :aetitle, :string, null: false
  end
end
