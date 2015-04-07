class AddPatientsBirthDateToEntries < ActiveRecord::Migration
  def up
    add_column :entries, :patients_birth_date, :date
    change_column :entries, :patients_birth_date, :date, null: false
  end

  def down
    remove_column :entries, :patients_birth_date
  end
end
