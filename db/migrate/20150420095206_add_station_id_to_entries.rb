class AddStationIdToEntries < ActiveRecord::Migration
  def change
    add_reference :entries, :station, index: true
    add_foreign_key :entries, :stations
  end
end
