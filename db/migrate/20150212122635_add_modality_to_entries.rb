class AddModalityToEntries < ActiveRecord::Migration
  def up
    add_column :entries, :modality, :string
    change_column :entries, :modality, :string, null: false
  end

  def down
    remove_column :entries, :modality
  end
end
