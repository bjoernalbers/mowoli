class AddReferringPhysiciansNameToEntries < ActiveRecord::Migration
  def up
    add_column :entries, :referring_physicians_name, :string
    change_column :entries, :referring_physicians_name, :string, null: false
  end

  def down
    remove_column :entries, :referring_physicians_name
  end
end
