require 'rails_helper'
require 'active_attr/rspec'

module HL7
  module Segment
    describe OBX do
      let(:subject) { described_class.new }

      it 'includes all fields' do
        expect(subject.field_names).to eq [
          :set_id,
          :value_type,
          :observation_identifier,
          :observation_sub_id,
          :observation_value,
          :units,
          :references_range,
          :abnormal_flags,
          :probability,
          :nature_of_abnormal_test,
          :observation_result_status,
          :effective_date_of_reference_range,
          :user_defined_access_checks,
          :datetime_of_the_observation,
          :producers_id,
          :responsible_observer,
          :observation_method,
          :equipment_instance_identifier,
          :datetime_of_the_analysis
        ]
      end

      [
        :effective_date_of_reference_range,
        :datetime_of_the_observation,
        :datetime_of_the_analysis
      ].each do |attribute|
        it { should have_attribute(attribute).of_type(DateTime) }
      end
    end
  end
end
