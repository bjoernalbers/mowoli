module HL7
  module Segment
    class PV1 < Base
      field :set_id
      field :patient_class
      field :assigned_patient_location
      field :admission_type
      field :preadmit_number
      field :prior_patient_location
      field :attending_doctor
      field :referring_doctor
      field :consulting_doctor
      field :hospital_service
      field :temporary_location
      field :preadmit_test_indicator
      field :readmission_indicator
      field :admin_source
      field :ambulatory_status
      field :vip_indicator
      field :admitting_doctor
      field :patient_type
      field :visit_number
      field :financial_class
      field :charge_price_indicator
      field :courtesy_code
      field :credit_rating
      field :contract_code
      field :contract_effective_date, type: DateTime
      field :contract_amount
      field :contract_period
      field :interest_code
      field :transfer_to_bad_dept_code
      field :transfer_to_bad_dept_date, type: DateTime
      field :bad_dept_agency_code
      field :bad_dept_transfer_amount
      field :bad_dept_recovery_amount
      field :delete_account_indicator
      field :delete_account_date, type: DateTime
      field :discharge_position
      field :discharged_to_location
      field :diet_type
      field :servicing_facility
      field :bed_status
      field :account_status
      field :pending_location
      field :prior_temporary_location
      field :admit_datetime, type: DateTime
      field :discharge_datetime, type: DateTime
      field :current_patient_balance
      field :total_charges
      field :total_adjustments
      field :total_payments
      field :alternate_visit_id
      field :visit_indicator
      field :other_healthcare_provider
    end
  end
end
