class RemoveScheduledStationAeTitleFromEntries < ActiveRecord::Migration
  def change
    remove_column :entries, :scheduled_station_ae_title
  end
end
