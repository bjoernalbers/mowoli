class AddIndexToStudyInstanceUidForEntries < ActiveRecord::Migration
  def change
    add_index :entries, :study_instance_uid, unique: true
  end
end
