json.key_format!

json.extract! @order,
  :id,
  :accession_number,
  :accession_numberx,
  :study_instance_uid,
  :patient_id,
  :patients_name,
  :patients_birth_date,
  :patients_sex,
  :referring_physicians_name,
  :scheduled_procedure_step_start_datetime
  
json.station do |json|
  json.extract! @order.station,
    :id,
    :name,
    :aetitle
  json.modality @order.station.modality.name
end
