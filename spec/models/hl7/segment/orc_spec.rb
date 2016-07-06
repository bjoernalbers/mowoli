require 'rails_helper'
require 'active_attr/rspec'

module HL7
  module Segment
    describe ORC do
      let(:subject) { described_class.new }

      it 'includes all fields' do
        expect(subject.field_names).to eq [
          :order_control,
          :placer_order_number,
          :filler_order_number,
          :placer_group_number,
          :order_status,
          :response_flag,
          :quantity_timing,
          :parent,
          :datetime_of_transaction,
          :entered_by,
          :verified_by,
          :ordering_provider,
          :enterers_location,
          :call_back_phone_number,
          :order_effective_datetime,
          :order_control_code_reason,
          :entering_organisation,
          :entering_device,
          :action_by,
          :advanced_beneficiary_notice_code,
          :ordering_facility_name,
          :ordering_facility_address,
          :ordering_facility_phone_number,
          :ordering_provider_address,
          :order_status_modifier,
          :advanced_beneficiary_notice_override_reason,
          :fillers_expected_availability_datetime,
          :confidentiality_code,
          :order_type,
          :enterer_authorization_mode
        ]
      end

      [
        :datetime_of_transaction,
        :order_effective_datetime,
        :fillers_expected_availability_datetime,
      ].each do |attribute|
        it { should have_attribute(attribute).of_type(DateTime) }
      end

      #describe '#encoding_characters' do
        #it 'has default' do
          #expect(subject.encoding_characters).to eq '^~\&'
        #end
      #end
    end
  end
end
