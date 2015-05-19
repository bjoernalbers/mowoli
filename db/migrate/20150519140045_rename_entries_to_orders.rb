class RenameEntriesToOrders < ActiveRecord::Migration
  def change
    rename_table :entries, :orders
  end
end
