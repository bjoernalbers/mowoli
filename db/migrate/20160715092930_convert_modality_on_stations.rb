class ConvertModalityOnStations < ActiveRecord::Migration
  class Modality < ActiveRecord::Base
  end

  class Station < ActiveRecord::Base
  end

  def up
    Modality.reset_column_information
    Station.reset_column_information
    rename_column :stations, :modality, :old_modality
    add_column :stations, :modality_id, :integer
    Station.find_each do |station|
      modality = Modality.find_by!(name: station.old_modality)
      station.update_columns(modality_id: modality.id)
    end
    change_column :stations, :modality_id, :integer, null: false
    remove_column :stations, :old_modality
  end

  def down
    Modality.reset_column_information
    Station.reset_column_information
    rename_column :stations, :modality_id, :old_modality_id
    add_column :stations, :modality, :string
    Station.find_each do |station|
      modality = Modality.find(station.old_modality_id)
      station.update_columns(modality: modality.name)
    end
    change_column :stations, :modality, :string, null: false
    remove_column :stations, :old_modality_id
  end
end
