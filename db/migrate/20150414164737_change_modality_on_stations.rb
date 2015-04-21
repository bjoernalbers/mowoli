class ChangeModalityOnStations < ActiveRecord::Migration
  def change
    change_column :stations, :modality, :string, null: false
  end
end
