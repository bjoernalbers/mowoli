class AddAccessionNumberToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :accession_number, :string
  end
end
