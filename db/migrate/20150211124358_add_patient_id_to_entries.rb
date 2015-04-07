class AddPatientIdToEntries < ActiveRecord::Migration
  def up
    add_column :entries, :patient_id, :string
    change_column :entries, :patient_id, :string, null: false
  end

  def down
    remove_column :entries, :patient_id
  end
end
