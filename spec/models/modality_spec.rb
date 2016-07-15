require 'rails_helper'

describe Modality do
  let(:subject) { build(:modality) }

  it 'has valid factory' do
    expect(subject).to be_valid
  end

  context 'with seeded database' do
    before do
      Rails.application.load_seed
    end

    it 'is populated' do
      expect(described_class.count).to eq 48
    end
  end

  it 'is translated' do
    expect(described_class.model_name.human).to eq 'Modalität'
    {
      name:         'Name',
      description: 'Beschreibung'
    }.each do |attr,translation|
      expect(described_class.human_attribute_name(attr)).to eq translation
    end
  end

  describe '#name' do
    it 'must be present' do
      subject.name = nil
      expect(subject).to be_invalid
      expect(subject.errors[:name]).to be_present
      expect{subject.save!(validate: false) }.
        to raise_error(ActiveRecord::ActiveRecordError)
    end

    it 'must be unique' do
      subject.name = create(:modality).name
      expect(subject).to be_invalid
      expect(subject.errors[:name]).to be_present
      expect{subject.save!(validate: false) }.
        to raise_error(ActiveRecord::ActiveRecordError)
    end

    it 'must have 16 chars max' do
      subject.name = 'A'*16
      expect(subject).to be_valid
      subject.name = 'A'*17
      expect(subject).to be_invalid
      expect(subject.errors[:name]).to be_present
    end

    it 'must only include caps, digits, space and underscore' do
      [ 'CT', ' C T ', 'CT1', 'CT_1' ].each do |valid_name|
        subject.name = valid_name
        expect(subject).to be_valid
      end
      [ 'CT.', 'Ct', 'ÜS', "NM\t" ].each do |invalid_name|
        subject.name = invalid_name
        expect(subject).to be_invalid
        expect(subject.errors[:name]).to be_present
      end
    end
  end

  describe '#description' do
    it 'must be present' do
      subject.description = nil
      expect(subject).to be_invalid
      expect(subject.errors[:description]).to be_present
      expect{subject.save!(validate: false) }.
        to raise_error(ActiveRecord::ActiveRecordError)
    end
  end

  describe '#to_s' do
    it 'returns name' do
      expect(subject.to_s).to eq subject.name
    end
  end
end
