require 'rails_helper'
require 'active_attr/rspec'

module HL7
  module Segment
    describe MSH do
      let(:subject) { described_class.new }

      it 'includes all fields' do
        expect(subject.field_names).to eq [
          :encoding_characters,
          :sending_application,
          :sending_facility,
          :receiving_application,
          :receiving_facility,
          :datetime_of_message,
          :security,
          :message_type,
          :message_control_id,
          :processing_id,
          :version_id,
          :sequence_number,
          :continuation_pointer,
          :accept_acknowledge_type,
          :application_acknowledge_type,
          :country_code,
          :character_set,
          :principal_language_of_message,
          :alternate_character_set_handling_scheme,
          :message_profile_id
        ]
      end

      [
        :datetime_of_message,
      ].each do |attribute|
        it { should have_attribute(attribute).of_type(DateTime) }
      end

      describe '#encoding_characters' do
        it 'has default' do
          expect(subject.encoding_characters).to eq '^~\&'
        end
      end

      describe '#sending_application' do
        it 'has default' do
          expect(subject.sending_application).to eq 'Mowoli'
        end
      end

      describe '#message_type' do
        it 'has default' do
          expect(subject.message_type).to eq 'ORM^O01^ORM_O01'
        end
      end

      describe '#message_control_id' do
        it 'has by default a length of 20' do
          expect(subject.message_control_id.length).to eq 20
        end

        it 'has by default a random string' do
          other = described_class.new
          expect(subject.message_control_id).not_to eq(other.message_control_id)
        end
      end

      describe '#version_id' do
        it 'has default' do
          expect(subject.version_id).to eq '2.3'
        end
      end
    end
  end
end
