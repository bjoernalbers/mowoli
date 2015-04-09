require 'rails_helper'

RSpec.describe Entry, type: :model do
  let(:entry) { FactoryGirl.build(:entry) }

  it 'has valid factory' do
    expect(entry).to be_valid
  end

  describe '#accession_number' do
    it 'is required' do
      entry.accession_number = nil
      expect(entry).not_to be_valid
      expect{ entry.save(validate: false) }.to raise_error
    end

    it 'contains max. 16 characters' do
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
    it 'is required' do
      entry.study_instance_uid = nil
      expect(entry).not_to be_valid
      expect{ entry.save(validate: false) }.to raise_error
    end

    it 'contains max. 64 characters' do
      entry.study_instance_uid = '0' * 65
      expect(entry).not_to be_valid
      entry.study_instance_uid = '0' * 64
      expect(entry).to be_valid
    end

    it 'must contain only digits and dots' do
      uid = '1.2.3.45.67890'
      entry.study_instance_uid = uid
      expect(entry).to be_valid
      %w(A a , _).each do |char|
        entry.study_instance_uid = uid + char
        expect(entry).not_to be_valid
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
    it 'is required' do
      entry.modality = nil
      expect(entry).not_to be_valid
      expect{ entry.save(validate: false) }.to raise_error
    end
  end

  describe '#scheduled_station_ae_title' do
    it 'is required' do
      entry.scheduled_station_ae_title = nil
      expect(entry).not_to be_valid
      expect{ entry.save(validate: false) }.to raise_error
    end
  end

  describe '#scheduled_procedure_step_start_date'
    #it 'returns entry creation date'

  describe '#scheduled_procedure_step_start_time'
    #it 'returns entry creation time'

  describe '#scheduled_performing_physicians_name'
end
