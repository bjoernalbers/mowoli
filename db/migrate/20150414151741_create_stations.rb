class CreateStations < ActiveRecord::Migration
  def change
    create_table :stations do |t|
      t.string :name
      t.string :modality
      t.string :aetitle

      t.timestamps null: false
    end
    add_index :stations, :name, unique: true
  end
end
