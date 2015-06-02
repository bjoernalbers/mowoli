require 'rails_helper'

RSpec.describe PersonName, type: :model do
  describe '.attribute_names' do
    it 'returns all attributes names' do
      expect(PersonName.attributes).to eq(
        [:family, :given, :middle, :prefix, :suffix])
    end
  end

  it 'has factory for basic attributes' do
    person = build(:person_name)
    [:family, :given].each do |attr|
      expect(person.send(attr)).to be_present
    end
  end

  it 'has factory for all attributes' do
    person = build(:full_person_name)
    [:family, :given, :middle, :prefix, :suffix].each do |attr|
      expect(person.send(attr)).to be_present
    end
  end

  describe '#to_s' do
    it 'joins components by "^"' do
      attributes = {
        family: 'Norris',
        given:  'Chuck',
        middle: 'Theodor-Maria',
        prefix: 'Mr.',
        suffix: 'CEO'
      }
      person_name = PersonName.new(attributes)
      expect(person_name.to_s).to eq 'Norris^Chuck^Theodor-Maria^Mr.^CEO'
    end

    it 'strips delimiters for trailing empty components' do
      attributes = {
        family: 'Norris',
        given:  'Chuck',
      }
      person_name = PersonName.new(attributes)
      expect(person_name.to_s).to eq 'Norris^Chuck'
    end

    it 'preserve delimiters for inner empty components' do
      attributes = {
        family: 'Norris',
        given:  'Chuck',
        prefix: 'Mr.',
        suffix: 'CEO'
      }
      person_name = PersonName.new(attributes)
      expect(person_name.to_s).to eq 'Norris^Chuck^^Mr.^CEO'
    end
  end
end
