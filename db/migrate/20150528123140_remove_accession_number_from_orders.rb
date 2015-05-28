class RemoveAccessionNumberFromOrders < ActiveRecord::Migration
  def up
    remove_index :orders, column: :accession_number, unique: true
    remove_column :orders, :accession_number, null: false
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
