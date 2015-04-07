class AddScheduledStationAeTitleToEntries < ActiveRecord::Migration
  def up
    add_column :entries, :scheduled_station_ae_title, :string
    change_column :entries, :scheduled_station_ae_title, :string, null: false
  end

  def down
    remove_column :entries, :scheduled_station_ae_title
  end
end
