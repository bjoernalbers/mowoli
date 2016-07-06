# Common Order
module HL7
  module Segment
    class ORC < Base
      field :order_control
      field :placer_order_number
      field :filler_order_number
      field :placer_group_number
      field :order_status
      field :response_flag
      field :quantity_timing
      field :parent
      field :datetime_of_transaction, type: DateTime
      field :entered_by
      field :verified_by
      field :ordering_provider
      field :enterers_location
      field :call_back_phone_number
      field :order_effective_datetime, type: DateTime
      field :order_control_code_reason
      field :entering_organisation
      field :entering_device
      field :action_by
      field :advanced_beneficiary_notice_code
      field :ordering_facility_name
      field :ordering_facility_address
      field :ordering_facility_phone_number
      field :ordering_provider_address
      field :order_status_modifier
      field :advanced_beneficiary_notice_override_reason
      field :fillers_expected_availability_datetime, type: DateTime
      field :confidentiality_code
      field :order_type
      field :enterer_authorization_mode
    end
  end
end
