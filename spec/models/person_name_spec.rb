require 'rails_helper'

RSpec.describe PersonName, type: :model do
  describe '.attribute_names' do
    it 'returns all attributes names' do
      expect(PersonName.attributes).to eq(
        [:family, :given, :middle, :prefix, :suffix])
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
