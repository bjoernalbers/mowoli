class AddPatientsSexToEntries < ActiveRecord::Migration
  def up
    add_column :entries, :patients_sex, :string
    change_column :entries, :patients_sex, :string, null: false
  end

  def down
    remove_column :entries, :patients_sex
  end
end
