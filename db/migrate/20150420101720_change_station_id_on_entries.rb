class ChangeStationIdOnEntries < ActiveRecord::Migration
  def change
    change_column :entries, :station_id, :integer, null: false
  end
end
