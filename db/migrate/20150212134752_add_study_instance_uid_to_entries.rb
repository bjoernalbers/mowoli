class AddStudyInstanceUidToEntries < ActiveRecord::Migration
  def up
    add_column :entries, :study_instance_uid, :string
    change_column :entries, :study_instance_uid, :string, null: false
  end

  def down
    remove_column :entries, :study_instance_uid
  end
end
