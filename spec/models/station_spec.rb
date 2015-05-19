require 'rails_helper'

RSpec.describe Station, type: :model do
  it 'has valid factory' do
    2.times { expect(create(:station)).to be_valid }
  end

  it 'has many orders' do
    station = create(:station)
    order = create(:order, station: station)
    expect(station.orders).to match_array [order]
  end

  describe '#name' do
    it 'must be present' do
      station = build(:station, name: nil)
      expect(station).to be_invalid
      expect(station.errors[:name]).to be_present
      expect{ station.save!(validate: false) }.to raise_error
    end

    it 'must be unique' do
      other = create(:station)
      station = build(:station, name: other.name)
      expect(station).to be_invalid
      expect(station.errors[:name]).to be_present
      expect{ station.save!(validate: false) }.to raise_error
    end
  end

  describe '#modality' do
    it 'must be present' do
      station = build(:station, modality: nil)
      expect(station).to be_invalid
      expect(station.errors[:modality]).to be_present
      expect{ station.save!(validate: false) }.to raise_error
    end

    it 'must include valid code' do
      valid_modality_codes = %w{CR CT DX MG MR NM US}
      valid_modality_codes.each do |code|
        station = build(:station, modality: code)
        expect(station).to be_valid
      end

      invalid_modality_codes = %w{AB Cr cT dx}
      invalid_modality_codes += ['', 'CT.', ' MR', "NM\t", 'ÜS']
      invalid_modality_codes.each do |code|
        station = build(:station, modality: code)
        expect(station).to be_invalid
        expect(station.errors[:modality]).to be_present
      end
    end
  end

  describe '#aetitle' do
    it 'must be present' do
      station = build(:station, aetitle: nil)
      expect(station).to be_invalid
      expect(station.errors[:aetitle]).to be_present
      expect{ station.save!(validate: false) }.to raise_error
    end

    it 'must include 16 characters max' do
      station = build(:station, aetitle: 'A'*16)
      expect(station).to be_valid

      station = build(:station, aetitle: 'A'*17)
      expect(station).to be_invalid
      expect(station.errors[:aetitle]).to be_present
    end

    it 'must include only upper case characters, underscores and digits' do
      station = build(:station, aetitle: 'PHILIPS_MR_1')
      expect(station).to be_valid

      invalid_aetitles = [
        'philips',
        'Philips',
        'PHILIPS-1',
        'PHILIPS 1',
        'PHILIPS,1'
      ]
      invalid_aetitles.each do |aetitle|
        station = build(:station, aetitle: aetitle)
        expect(station).to be_invalid
        expect(station.errors[:aetitle]).to be_present
      end
    end
  end
end
