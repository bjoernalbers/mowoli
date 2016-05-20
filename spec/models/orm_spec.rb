require 'rails_helper'

describe ORM do
  let(:segments) { %w(msh pid pv1 orc obr) }
  #let(:order) { build(:order) } # NOTE: Unsaved orders don't have a study instance uid.
  let(:order) { create(:order) }
  let(:subject) { described_class.new(order) }

  describe '#to_hl7' do
    it 'does not raise error' do
      expect { subject.to_hl7 }.not_to raise_error
    end

    it 'joins segments by carriage return' do
      segments.each do |segment|
        allow(subject).to receive(segment).
          and_return double(segment, to_hl7: segment)
      end
      expect(subject.to_hl7).to eq segments.join("\r")
    end
  end
end
