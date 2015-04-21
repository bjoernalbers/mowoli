class AddIndexToAccessionNumberOnEntries < ActiveRecord::Migration
  def change
    add_index :entries, :accession_number, unique: true
  end
end
