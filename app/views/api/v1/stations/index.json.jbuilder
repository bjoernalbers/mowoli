json.array!(@stations) do |station|
  json.extract! station, :id, :name, :modality, :aetitle
end
