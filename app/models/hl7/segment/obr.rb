# Observation Request
module HL7
  module Segment
    class OBR < Base
      field :set_id
      field :placer_order_number
      field :filler_order_number
      field :universal_service_identifier
      field :priority
      field :requested_datetime, type: DateTime
      field :observation_datetime, type: DateTime
      field :observation_end_datetime, type: DateTime
      field :collection_volume
      field :collection_identifier
      field :specimen_action_code
      field :danger_code
      field :relevant_clinical_information
      field :specimen_received_datetime, type: DateTime
      field :specimen_source
      field :ordering_provider
      field :order_callback_phone_number
      field :placer_field_1
      field :placer_field_2
      field :filler_field_1
      field :filler_field_2, default: 'DL1'
      field :result_status_change_datetime, type: DateTime
      field :charge_to_practice
      field :diagnostic_serv_sect_id
      field :result_status
      field :parent_result
      field :quantity_timing
      field :result_copies_to
      field :parent
      field :transportation_mode
      field :reason_for_study
      field :principal_result_interpreter
      field :assistant_result_interpreter
      field :technician
      field :transcriptionist
      field :scheduled_datetime, type: DateTime
      field :number_of_sample_containers
      field :transport_logistics_of_collected_sample
      field :collectors_comment
      field :transport_arrangement_responsibility
      field :transport_arranged
      field :escort_required
      field :planned_patient_transport_comment
      field :procedure_code
      field :procedure_code_modifier
      field :placer_supplemental_service_information
      field :filler_supplemental_service_information
      field :medical_necessary_duplicate_procedure_reason
      field :result_handling
    end
  end
end
