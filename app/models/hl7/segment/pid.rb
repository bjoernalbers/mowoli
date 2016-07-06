module HL7
  module Segment
    class PID < Base
      field :set_id
      field :external_patient_id
      field :internal_patient_id
      field :alternate_patient_id
      field :patient_name
      field :mothers_maiden_name
      field :date_of_birth, type: DateTime
      field :sex
      field :patient_alias
      field :race
      field :patient_address
      field :country_code
      field :phone_number_home
      field :phone_number_business
      field :language
      field :marital_status
      field :religion
      field :patient_account_number
      field :social_security_number
      field :drivers_license_number
      field :mothers_identifier
      field :ethnic_group
      field :birth_place
      field :multiple_birth_indicator
      field :birth_order
      field :citizenship
      field :veterans_military_status
      field :nationality
      field :patients_death_datetime, type: DateTime
      field :patients_death_indicator
      field :identity_unknown_indicator
      field :identity_reliability_code
      field :last_update_datetime, type: DateTime
      field :last_update_facility
      field :species_code
      field :breed_code
      field :strain
      field :production_class_code
      field :tribal_citizenship
    end
  end
end
