json.array!(@orders) do |order|
  json.extract! order, :id, :accession_number, :referring_physicians_name, :patients_name, :patient_id, :patients_birth_date, :patients_sex, :study_instance_uid, :requested_procedure_description, :modality, :scheduled_station_ae_title
  json.url order_url(order, format: :json)
end
