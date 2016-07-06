require 'rails_helper'
require 'active_attr/rspec'

module HL7
  module Segment
    describe AL1 do
      let(:subject) { described_class.new }

      it 'includes all fields' do
        expect(subject.field_names).to eq [
          :event_type_code,
          :allergen_type_code,
          :allergen_code,
          :allergy_severity_code,
          :allergy_reaction_code,
          :identification_date
        ]
      end

      [
        :identification_date
      ].each do |attribute|
        it { should have_attribute(attribute).of_type(DateTime) }
      end
    end
  end
end
