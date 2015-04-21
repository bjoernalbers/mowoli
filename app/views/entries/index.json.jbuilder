json.array!(@entries) do |entry|
  json.extract! entry, :id, :accession_number, :referring_physicians_name, :patients_name, :patient_id, :patients_birth_date, :patients_sex, :study_instance_uid, :requesting_physicians_name, :requested_procedure_description, :modality, :scheduled_station_ae_title
  json.url entry_url(entry, format: :json)
end
