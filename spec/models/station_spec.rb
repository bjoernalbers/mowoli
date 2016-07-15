# encoding: utf-8
require 'rails_helper'

describe Station do
  it 'has valid factory' do
    2.times { expect(create(:station)).to be_valid }
  end


  it 'has many orders' do
    subject = create(:station)
    order = create(:order, station: subject)
    expect(subject.orders).to match_array [order]
  end

  context 'when destroyed' do
    let(:subject) { create(:station) }

    it 'deletes depenend orders' do
      order = create(:order, station: subject)
      expect{ subject.destroy }.to change(Order, :count).by(-1)
    end
  end

  describe '#modality' do
    let(:subject) { build(:station) }

    it 'must be present' do
      subject.modality = nil
      expect(subject).to be_invalid
      expect(subject.errors[:modality]).to be_present
      expect{subject.save!(validate: false) }.
        to raise_error(ActiveRecord::ActiveRecordError)
    end
  end

  describe '#name' do
    it 'must be present' do
      subject = build(:station, name: nil)
      expect(subject).to be_invalid
      expect(subject.errors[:name]).to be_present
      expect{ subject.save!(validate: false) }.to raise_error
    end
  end

  describe '#aetitle' do
    it 'must be present' do
      subject = build(:station, aetitle: nil)
      expect(subject).to be_invalid
      expect(subject.errors[:aetitle]).to be_present
      expect{ subject.save!(validate: false) }.to raise_error
    end

    it 'must include 16 characters max' do
      subject = build(:station, aetitle: 'A'*16)
      expect(subject).to be_valid

      subject = build(:station, aetitle: 'A'*17)
      expect(subject).to be_invalid
      expect(subject.errors[:aetitle]).to be_present
    end

    it 'must include only characters, digits, underscores, dashes and dots' do
      valid_aetitles = [
        'PHILIPS_MR_1',
        'PHILIPS-1',
        'PHILIPS.1',
        'philips',
        'Philips'
      ]
      valid_aetitles.each do |aetitle|
        subject = build(:station, aetitle: aetitle)
        expect(subject).to be_valid
      end

      invalid_aetitles = [
        'PHILIPS 1',
        'PHILIPS,1'
      ]
      invalid_aetitles.each do |aetitle|
        subject = build(:station, aetitle: aetitle)
        expect(subject).to be_invalid
        expect(subject.errors[:aetitle]).to be_present
      end
    end
  end

  describe '#character_set' do
    it 'defaults to "ISO_IR 100"' do
      default_character_set = 'ISO_IR 100'
      expect(subject.character_set).to eq default_character_set
    end

    it 'can be "ISO_IR 192"' do
      new_character_set = 'ISO_IR 192'
      subject.character_set = new_character_set
      expect(subject.character_set).to eq new_character_set
    end

    it 'can not be unknown value' do
      unknown_character_set = 'ISO_IR 42'
      expect {
        subject.character_set = unknown_character_set
      }.to raise_error(ArgumentError)
    end
  end

  describe 'receives_orders_via_hl7' do
    let(:subject) { build(:station) }

    it 'defaults to false' do
      expect(subject.receives_orders_via_hl7).to be_falsey
    end
  end
end
