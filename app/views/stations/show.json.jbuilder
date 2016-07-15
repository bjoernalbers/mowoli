json.extract! @station, :id, :name, :aetitle, :created_at, :updated_at
json.modality @station.modality.name
