class RemoveModalityFromEntries < ActiveRecord::Migration
  def change
    remove_column :entries, :modality
  end
end
