class AddRequestedProcedureDescriptionToEntries < ActiveRecord::Migration
  def up
    add_column :entries, :requested_procedure_description, :string
    change_column :entries, :requested_procedure_description, :string, null: false
  end

  def down
    add_column :entries, :requested_procedure_description
  end
end
