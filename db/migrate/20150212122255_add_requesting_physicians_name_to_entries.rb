class AddRequestingPhysiciansNameToEntries < ActiveRecord::Migration
  def up
    add_column :entries, :requesting_physicians_name, :string
    change_column :entries, :requesting_physicians_name, :string, null: false
  end

  def down
    remove_column :entries, :requesting_physicians_name
  end
end
