require 'rails_helper'
require 'active_attr/rspec'

module HL7
  module Segment
    describe PV1 do
      let(:subject) { described_class.new }

      it 'includes all fields' do
        expect(subject.field_names).to eq [
          :set_id,
          :patient_class,
          :assigned_patient_location,
          :admission_type,
          :preadmit_number,
          :prior_patient_location,
          :attending_doctor,
          :referring_doctor,
          :consulting_doctor,
          :hospital_service,
          :temporary_location,
          :preadmit_test_indicator,
          :readmission_indicator,
          :admin_source,
          :ambulatory_status,
          :vip_indicator,
          :admitting_doctor,
          :patient_type,
          :visit_number,
          :financial_class,
          :charge_price_indicator,
          :courtesy_code,
          :credit_rating,
          :contract_code,
          :contract_effective_date,
          :contract_amount,
          :contract_period,
          :interest_code,
          :transfer_to_bad_dept_code,
          :transfer_to_bad_dept_date,
          :bad_dept_agency_code,
          :bad_dept_transfer_amount,
          :bad_dept_recovery_amount,
          :delete_account_indicator,
          :delete_account_date,
          :discharge_position,
          :discharged_to_location,
          :diet_type,
          :servicing_facility,
          :bed_status,
          :account_status,
          :pending_location,
          :prior_temporary_location,
          :admit_datetime,
          :discharge_datetime,
          :current_patient_balance,
          :total_charges,
          :total_adjustments,
          :total_payments,
          :alternate_visit_id,
          :visit_indicator,
          :other_healthcare_provider
        ]
      end

      [
        :contract_effective_date,
        :transfer_to_bad_dept_date,
        :delete_account_date,
        :admit_datetime,
        :discharge_datetime
      ].each do |attribute|
        it { should have_attribute(attribute).of_type(DateTime) }
      end
    end
  end
end
