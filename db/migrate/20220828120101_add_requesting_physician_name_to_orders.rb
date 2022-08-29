class AddRequestingPhysicianNameToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :requesting_physicians_name, :string
  end
end
