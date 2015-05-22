json.key_format!

json.extract! @order,
  :id,
  :accession_number,
  :study_instance_uid,
  :patient_id,
  :patients_name,
  :patients_birth_date,
  :patients_sex

json.station do |json|
  json.extract! @order.station,
    :id,
    :name,
    :modality,
    :aetitle
end
