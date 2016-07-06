require 'rails_helper'
require 'active_attr/rspec'

module HL7
  module Segment
    describe ZDS do
      let(:subject) { described_class.new }

      it 'includes all fields' do
        expect(subject.field_names).to eq [
          :study_instance_uid
        ]
      end
    end
  end
end
