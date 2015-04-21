json.array!(@stations) do |station|
  json.extract! station, :id, :name, :modality, :aetitle
  json.url station_url(station, format: :json)
end
