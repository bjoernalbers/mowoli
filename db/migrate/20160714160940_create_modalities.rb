class CreateModalities < ActiveRecord::Migration
  def change
    create_table :modalities do |t|
      t.string :name, null: false
      t.string :description, null: false

      t.timestamps null: false
    end
    add_index :modalities, :name, unique: true
  end
end
