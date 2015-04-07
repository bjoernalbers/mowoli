class AddPatientsNameToEntries < ActiveRecord::Migration
  def up
    add_column :entries, :patients_name, :string
    change_column :entries, :patients_name, :string, null: false
  end

  def down
    remove_column :entries, :patients_name
  end
end
