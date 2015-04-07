class ChangeAccessionNumberOnEntries < ActiveRecord::Migration
  def change
    change_column :entries, :accession_number, :string, null: false
  end
end
