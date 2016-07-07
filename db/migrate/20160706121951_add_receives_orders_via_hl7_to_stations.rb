class AddReceivesOrdersViaHl7ToStations < ActiveRecord::Migration
  class Station < ActiveRecord::Base
  end

  def up
    Station.reset_column_information
    add_column :stations, :receives_orders_via_hl7, :boolean
    Station.update_all(receives_orders_via_hl7: false)
    change_column :stations, :receives_orders_via_hl7, :boolean, null: false, default: false
  end

  def down
    remove_column :stations, :receives_orders_via_hl7, :boolean
  end
end
