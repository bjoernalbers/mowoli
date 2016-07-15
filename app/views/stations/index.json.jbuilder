json.array!(@stations) do |station|
  json.extract! station, :id, :name, :aetitle
  json.modality station.modality.name
  json.url station_url(station, format: :json)
end
