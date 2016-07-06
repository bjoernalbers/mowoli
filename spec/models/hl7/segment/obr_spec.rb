require 'rails_helper'
require 'active_attr/rspec'

module HL7
  module Segment
    describe OBR do
      let(:subject) { described_class.new }

      it 'includes all fields' do
        expect(subject.field_names).to eq [
          :set_id,
          :placer_order_number,
          :filler_order_number,
          :universal_service_identifier,
          :priority,
          :requested_datetime,
          :observation_datetime,
          :observation_end_datetime,
          :collection_volume,
          :collection_identifier,
          :specimen_action_code,
          :danger_code,
          :relevant_clinical_information,
          :specimen_received_datetime,
          :specimen_source,
          :ordering_provider,
          :order_callback_phone_number,
          :placer_field_1,
          :placer_field_2,
          :filler_field_1,
          :filler_field_2,
          :result_status_change_datetime,
          :charge_to_practice,
          :diagnostic_serv_sect_id,
          :result_status,
          :parent_result,
          :quantity_timing,
          :result_copies_to,
          :parent,
          :transportation_mode,
          :reason_for_study,
          :principal_result_interpreter,
          :assistant_result_interpreter,
          :technician,
          :transcriptionist,
          :scheduled_datetime,
          :number_of_sample_containers,
          :transport_logistics_of_collected_sample,
          :collectors_comment,
          :transport_arrangement_responsibility,
          :transport_arranged,
          :escort_required,
          :planned_patient_transport_comment,
          :procedure_code,
          :procedure_code_modifier,
          :placer_supplemental_service_information,
          :filler_supplemental_service_information,
          :medical_necessary_duplicate_procedure_reason,
          :result_handling
        ]
      end

      [
        :requested_datetime,
        :observation_datetime,
        :observation_end_datetime,
        :specimen_received_datetime,
        :result_status_change_datetime,
        :scheduled_datetime,
      ].each do |attribute|
        it { should have_attribute(attribute).of_type(DateTime) }
      end

      describe '#filler_field_2' do
        it 'has default' do
          expect(subject.filler_field_2).to eq 'DL1'
        end
      end
    end
  end
end
