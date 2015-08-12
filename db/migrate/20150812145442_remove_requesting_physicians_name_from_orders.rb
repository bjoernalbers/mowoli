class RemoveRequestingPhysiciansNameFromOrders < ActiveRecord::Migration
  def up
    remove_column :orders, :requesting_physicians_name
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
