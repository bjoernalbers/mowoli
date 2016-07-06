require 'rails_helper'
require 'active_attr/rspec'

module HL7
  module Segment
    describe PID do
      let(:subject) { described_class.new }

      it 'includes all fields' do
        expect(subject.field_names).to eq [
          :set_id,
          :external_patient_id,
          :internal_patient_id,
          :alternate_patient_id,
          :patient_name,
          :mothers_maiden_name,
          :date_of_birth,
          :sex,
          :patient_alias,
          :race,
          :patient_address,
          :country_code,
          :phone_number_home,
          :phone_number_business,
          :language,
          :marital_status,
          :religion,
          :patient_account_number,
          :social_security_number,
          :drivers_license_number,
          :mothers_identifier,
          :ethnic_group,
          :birth_place,
          :multiple_birth_indicator,
          :birth_order,
          :citizenship,
          :veterans_military_status,
          :nationality,
          :patients_death_datetime,
          :patients_death_indicator,
          :identity_unknown_indicator,
          :identity_reliability_code,
          :last_update_datetime,
          :last_update_facility,
          :species_code,
          :breed_code,
          :strain,
          :production_class_code,
          :tribal_citizenship
        ]
      end

      [
        :date_of_birth,
        :patients_death_datetime,
        :last_update_datetime
      ].each do |attribute|
        it { should have_attribute(attribute).of_type(DateTime) }
      end
    end
  end
end
