require 'rails_helper'

RSpec.describe Entry, type: :model do
  let(:entry) { FactoryGirl.build(:entry) }

  it 'has valid factory' do
    expect(entry).to be_valid
  end

  describe '#station' do
    it 'is required' do
      entry = build(:entry, station: nil)
      expect(entry).to be_invalid
      expect(entry.errors[:station]).to be_present
      expect{ entry.save(validate: false) }.to raise_error
    end
  end

  describe '#station_name' do
    let(:station) { create(:station) }
    let(:entry) { build(:entry, station: nil) }

    before do
      allow(Station).to receive(:find_by).and_return(station)
      entry.station_name = 'Chunky Bacon'
      entry.valid?
    end

    it 'caches station name' do
      expect(entry.station_name).to eq 'Chunky Bacon'
    end

    it 'assigns station to entry' do
      expect(entry.station).to eq station
    end

    it 'finds station by name' do
      expect(Station).to have_received(:find_by).with(name: 'Chunky Bacon')
    end
  end

  describe '#accession_number' do
    it 'must be present' do
      entry.accession_number = nil
      expect(entry).not_to be_valid
      expect{ entry.save(validate: false) }.to raise_error
    end

    it 'must contains 16 characters max' do
      entry.accession_number = '0' * 17
      expect(entry).not_to be_valid
      entry.accession_number = '0' * 16
      expect(entry).to be_valid
    end

    it 'ignores leading or trailing spaces' do
      entry.accession_number = "\t 42\t  "
      entry.valid? # NOTE: Runs callback
      expect(entry.accession_number).to eq '42'
    end

    it 'must be unique' do
      other = create(:entry)
      entry = build(:entry, accession_number: other.accession_number)
      expect(entry).to be_invalid
      expect(entry.errors[:accession_number]).to be_present
      expect{ entry.save!(validate: false) }.to raise_error
    end

    #it 'shall have no control characters except ESC'
    #it 'shall have no backslash'
  end

  describe '#referring_physicians_name' do
    it 'is required' do
      entry.referring_physicians_name = nil
      expect(entry).not_to be_valid
      expect{ entry.save(validate: false) }.to raise_error
    end

    it 'contains max. 64 characters' do
      entry.referring_physicians_name = '0' * 65
      expect(entry).not_to be_valid
      entry.referring_physicians_name = '0' * 64
      expect(entry).to be_valid
    end
  end

  describe '#referring_physicians_name_attributes=' do
    it 'assigns referring_physicians_name' do
      entry.referring_physicians_name = nil
      entry.referring_physicians_name_attributes =
        { family: 'Norris', given: 'Chuck', prefix: 'Mr.' }
      expect(entry.referring_physicians_name).to eq 'Norris^Chuck^^Mr.'
    end
  end

  describe '#patients_name' do
    it 'is required' do
      entry.patients_name = nil
      expect(entry).not_to be_valid
      expect{ entry.save(validate: false) }.to raise_error
    end

    it 'contains max. 64 characters' do
      entry.patients_name = '0' * 65
      expect(entry).not_to be_valid
      entry.patients_name = '0' * 64
      expect(entry).to be_valid
    end
  end

  describe '#patients_name_attributes=' do
    it 'assigns patients_name' do
      entry.patients_name = nil
      entry.patients_name_attributes =
        { family: 'Norris', given: 'Chuck', prefix: 'Mr.' }
      expect(entry.patients_name).to eq 'Norris^Chuck^^Mr.'
    end
  end

  describe '#patient_id' do
    it 'is required' do
      entry.patient_id = nil
      expect(entry).not_to be_valid
      expect{ entry.save(validate: false) }.to raise_error
    end

    it 'contains max. 64 characters' do
      entry.patient_id = '0' * 65
      expect(entry).not_to be_valid
      entry.patient_id = '0' * 64
      expect(entry).to be_valid
    end
  end

  describe '#patients_birth_date' do
    it 'is required' do
      entry.patients_birth_date = nil
      expect(entry).not_to be_valid
      expect{ entry.save(validate: false) }.to raise_error
    end

    it 'returns a DICOM-conform representation' do
      entry.patients_birth_date = Date.new(2015, 5, 26)
      expect(entry.patients_birth_date.to_s(:dicom)).to eq '20150526'
    end
  end

  describe '#patients_sex' do
    it 'is required' do
      entry.patients_sex = nil
      expect(entry).not_to be_valid
      expect{ entry.save(validate: false) }.to raise_error
    end

    {
      'F' => 'Female',
      'M' => 'Male',
      'O' => 'Other'
    }.each do |code,description|
      it "can be '#{code}' (#{description})" do
        entry.patients_sex = code
        expect(entry).to be_valid
      end
    end

    it 'can not include other codes' do
      ['f', 'm', 'o', 'a', 'z', ',', '.', "\t", ' ', '-', 0, 9].each do |code|
        entry.patients_sex = code
        expect(entry).not_to be_valid
        expect(entry.errors[:patients_sex]).to be_present
      end
    end
  end

  describe '#study_instance_uid' do
    let(:generated_uid) { '1.2.3.42' }

    before do
      allow(UniqueIdentifier).to receive(:new).
        and_return(double(generate: generated_uid))
    end

    context 'when not set' do
      let(:entry) { FactoryGirl.build(:entry, study_instance_uid: nil) }

      it 'assigns generated UID before validation' do
        expect(entry.study_instance_uid).to be nil
        entry.valid?
        expect(entry.study_instance_uid).to eq generated_uid
      end
    end

    context 'when set' do
      let(:custom_uid) { '1.23.567' }
      let(:entry) { FactoryGirl.build(:entry, study_instance_uid: custom_uid) }

      it 'does not assign generated UID before validation' do
        expect(entry.study_instance_uid).to eq custom_uid
        entry.valid?
        expect(entry.study_instance_uid).to eq custom_uid
      end
    end

    it 'validates uniqueness' do
      other = FactoryGirl.create(:entry, study_instance_uid: generated_uid)
      entry = FactoryGirl.build(:entry, study_instance_uid: generated_uid)
      expect(entry).to be_invalid
      expect(entry.errors[:study_instance_uid]).to be_present
      expect{ entry.save!(validate: false) }.to raise_error
    end

    it 'validates length' do
      valid_uid = '1.2.' + '3' * 60
      entry = FactoryGirl.build(:entry, study_instance_uid: valid_uid)
      expect(entry.study_instance_uid.size).to eq 64
      expect(entry).to be_valid

      too_long_uid = '1.2.' + '3' * 61
      entry = FactoryGirl.build(:entry, study_instance_uid: too_long_uid)
      expect(entry.study_instance_uid.size).to eq 65
      expect(entry).to be_invalid
      expect(entry.errors[:study_instance_uid]).to be_present
    end

    it 'validates format' do
      uid = '1.2.3.45.67890'
      entry.study_instance_uid = uid
      expect(entry).to be_valid
      [
        'A', 'a', # No letters
        '_',      # No special characters
        #'.0123'   # No segment with leading zero #TODO Test this too!
      ].each do |invalid_suffix|
        entry.study_instance_uid = uid + invalid_suffix
        expect(entry).to be_invalid
      end
    end
  end

  describe '#requesting_physicians_name' do
    it 'is required' do
      entry.requesting_physicians_name = nil
      expect(entry).not_to be_valid
      expect{ entry.save(validate: false) }.to raise_error
    end

    it 'contains max. 64 characters' do
      entry.requesting_physicians_name = '0' * 65
      expect(entry).not_to be_valid
      entry.requesting_physicians_name = '0' * 64
      expect(entry).to be_valid
    end
  end

  describe '#requesting_physicians_name_attributes=' do
    it 'assigns requesting_physicians_name' do
      entry.requesting_physicians_name = nil
      entry.requesting_physicians_name_attributes =
        { family: 'Norris', given: 'Chuck', prefix: 'Mr.' }
      expect(entry.requesting_physicians_name).to eq 'Norris^Chuck^^Mr.'
    end
  end

  describe '#requested_procedure_description' do
    it 'is required' do
      entry.requested_procedure_description = nil
      expect(entry).not_to be_valid
      expect{ entry.save(validate: false) }.to raise_error
    end
  end

  describe '#modality' do
    it 'returns modality from station' do
      entry = build(:entry, station: nil)
      expect(entry.modality).to be nil

      station = create(:station, modality: 'DX')
      entry = build(:entry, station: station)
      expect(entry.modality).to eq 'DX'
    end
  end

  describe '#scheduled_station_ae_title' do
    it 'returns aetitle from station' do
      entry = build(:entry, station: nil)
      expect(entry.scheduled_station_ae_title).to be nil

      station = create(:station, aetitle: 'CHUNKY_BACON')
      entry = build(:entry, station: station)
      expect(entry.scheduled_station_ae_title).to eq 'CHUNKY_BACON'
    end
  end

  describe '#scheduled_procedure_step_start_date'
    #it 'returns entry creation date'

  describe '#scheduled_procedure_step_start_time'
    #it 'returns entry creation time'

  describe '#scheduled_performing_physicians_name'
end
