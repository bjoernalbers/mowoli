require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:order) { FactoryGirl.build(:order) }

  it 'has valid factory' do
    expect(order).to be_valid
  end

  context 'on create' do
    it 'creates worklist file' do
      worklist_file = double('worklist_file')
      allow(WorklistFile).to receive(:new).and_return(worklist_file)
      allow(worklist_file).to receive(:create)

      order = FactoryGirl.create(:order)

      expect(WorklistFile).to have_received(:new).with(order)
      expect(worklist_file).to have_received(:create)
    end
  end

  context 'on destroy' do
    it 'creates worklist file' do
      worklist_file = double('worklist_file')
      allow(WorklistFile).to receive(:new).and_return(worklist_file)
      allow(worklist_file).to receive(:create)
      allow(worklist_file).to receive(:delete)

      order = FactoryGirl.create(:order)

      expect(WorklistFile).to have_received(:new).with(order)
      expect(worklist_file).to have_received(:create)

      order.destroy

      expect(worklist_file).to have_received(:delete)
    end
  end

  describe '#station' do
    it 'is required' do
      order = build(:order, station: nil)
      expect(order).to be_invalid
      expect(order.errors[:station]).to be_present
      expect{ order.save(validate: false) }.to raise_error
    end
  end

  describe '#station_name' do
    let(:station) { create(:station) }
    let(:order) { build(:order, station: nil) }

    before do
      allow(Station).to receive(:find_by).and_return(station)
      order.station_name = 'Chunky Bacon'
      order.valid?
    end

    it 'caches station name' do
      expect(order.station_name).to eq 'Chunky Bacon'
    end

    it 'assigns station to order' do
      expect(order.station).to eq station
    end

    it 'finds station by name' do
      expect(Station).to have_received(:find_by).with(name: 'Chunky Bacon')
    end
  end

  describe '#accession_number' do
    it 'returns id as string' do
      order.id = 42
      expect(order.accession_number).to eq '42'
    end
  end

  describe '#referring_physicians_name' do
    it 'is required' do
      order.referring_physicians_name = nil
      expect(order).not_to be_valid
      expect{ order.save(validate: false) }.to raise_error
    end

    it 'contains max. 64 characters' do
      order.referring_physicians_name = '0' * 65
      expect(order).not_to be_valid
      order.referring_physicians_name = '0' * 64
      expect(order).to be_valid
    end
  end

  describe '#referring_physicians_name_attributes=' do
    it 'assigns referring_physicians_name' do
      order.referring_physicians_name = nil
      order.referring_physicians_name_attributes =
        { family: 'Norris', given: 'Chuck', prefix: 'Mr.' }
      expect(order.referring_physicians_name).to eq 'Norris^Chuck^^Mr.'
    end
  end

  describe '#patients_name' do
    it 'is required' do
      order.patients_name = nil
      expect(order).not_to be_valid
      expect{ order.save(validate: false) }.to raise_error
    end

    it 'contains max. 64 characters' do
      order.patients_name = '0' * 65
      expect(order).not_to be_valid
      order.patients_name = '0' * 64
      expect(order).to be_valid
    end
  end

  describe '#patients_name_attributes=' do
    it 'assigns patients_name' do
      order.patients_name = nil
      order.patients_name_attributes =
        { family: 'Norris', given: 'Chuck', prefix: 'Mr.' }
      expect(order.patients_name).to eq 'Norris^Chuck^^Mr.'
    end
  end

  describe '#patient_id' do
    it 'is required' do
      order.patient_id = nil
      expect(order).not_to be_valid
      expect{ order.save(validate: false) }.to raise_error
    end

    it 'contains max. 64 characters' do
      order.patient_id = '0' * 65
      expect(order).not_to be_valid
      order.patient_id = '0' * 64
      expect(order).to be_valid
    end
  end

  describe '#patients_birth_date' do
    it 'is required' do
      order.patients_birth_date = nil
      expect(order).not_to be_valid
      expect{ order.save(validate: false) }.to raise_error
    end

    it 'returns a DICOM-conform representation' do
      order.patients_birth_date = Date.new(2015, 5, 26)
      expect(order.patients_birth_date.to_s(:dicom)).to eq '20150526'
    end
  end

  describe '#patients_sex' do
    it 'is required' do
      order.patients_sex = nil
      expect(order).not_to be_valid
      expect{ order.save(validate: false) }.to raise_error
    end

    {
      'F' => 'Female',
      'M' => 'Male',
      'O' => 'Other'
    }.each do |code,description|
      it "can be '#{code}' (#{description})" do
        order.patients_sex = code
        expect(order).to be_valid
      end
    end

    it 'can not include other codes' do
      ['f', 'm', 'o', 'a', 'z', ',', '.', "\t", ' ', '-', 0, 9].each do |code|
        order.patients_sex = code
        expect(order).not_to be_valid
        expect(order.errors[:patients_sex]).to be_present
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
      let(:order) { FactoryGirl.build(:order, study_instance_uid: nil) }

      it 'assigns generated UID before validation' do
        expect(order.study_instance_uid).to be nil
        order.valid?
        expect(order.study_instance_uid).to eq generated_uid
      end
    end

    context 'when set' do
      let(:custom_uid) { '1.23.567' }
      let(:order) { FactoryGirl.build(:order, study_instance_uid: custom_uid) }

      it 'does not assign generated UID before validation' do
        expect(order.study_instance_uid).to eq custom_uid
        order.valid?
        expect(order.study_instance_uid).to eq custom_uid
      end
    end

    it 'validates uniqueness' do
      other = FactoryGirl.create(:order, study_instance_uid: generated_uid)
      order = FactoryGirl.build(:order, study_instance_uid: generated_uid)
      expect(order).to be_invalid
      expect(order.errors[:study_instance_uid]).to be_present
      expect{ order.save!(validate: false) }.to raise_error
    end

    it 'validates length' do
      valid_uid = '1.2.' + '3' * 60
      order = FactoryGirl.build(:order, study_instance_uid: valid_uid)
      expect(order.study_instance_uid.size).to eq 64
      expect(order).to be_valid

      too_long_uid = '1.2.' + '3' * 61
      order = FactoryGirl.build(:order, study_instance_uid: too_long_uid)
      expect(order.study_instance_uid.size).to eq 65
      expect(order).to be_invalid
      expect(order.errors[:study_instance_uid]).to be_present
    end

    it 'validates format' do
      uid = '1.2.3.45.67890'
      order.study_instance_uid = uid
      expect(order).to be_valid
      [
        'A', 'a', # No letters
        '_',      # No special characters
        #'.0123'   # No segment with leading zero #TODO Test this too!
      ].each do |invalid_suffix|
        order.study_instance_uid = uid + invalid_suffix
        expect(order).to be_invalid
      end
    end
  end

  describe '#requesting_physicians_name' do
    it 'is required' do
      order.requesting_physicians_name = nil
      expect(order).not_to be_valid
      expect{ order.save(validate: false) }.to raise_error
    end

    it 'contains max. 64 characters' do
      order.requesting_physicians_name = '0' * 65
      expect(order).not_to be_valid
      order.requesting_physicians_name = '0' * 64
      expect(order).to be_valid
    end
  end

  describe '#requesting_physicians_name_attributes=' do
    it 'assigns requesting_physicians_name' do
      order.requesting_physicians_name = nil
      order.requesting_physicians_name_attributes =
        { family: 'Norris', given: 'Chuck', prefix: 'Mr.' }
      expect(order.requesting_physicians_name).to eq 'Norris^Chuck^^Mr.'
    end
  end

  describe '#requested_procedure_description' do
    it 'is required' do
      order.requested_procedure_description = nil
      expect(order).not_to be_valid
      expect{ order.save(validate: false) }.to raise_error
    end
  end

  describe '#modality' do
    it 'returns modality from station' do
      order = build(:order, station: nil)
      expect(order.modality).to be nil

      station = create(:station, modality: 'DX')
      order = build(:order, station: station)
      expect(order.modality).to eq 'DX'
    end
  end

  describe '#scheduled_station_ae_title' do
    it 'returns aetitle from station' do
      order = build(:order, station: nil)
      expect(order.scheduled_station_ae_title).to be nil

      station = create(:station, aetitle: 'CHUNKY_BACON')
      order = build(:order, station: station)
      expect(order.scheduled_station_ae_title).to eq 'CHUNKY_BACON'
    end
  end

  describe '#scheduled_procedure_step_start_date'
    #it 'returns order creation date'

  describe '#scheduled_procedure_step_start_time'
    #it 'returns order creation time'

  describe '#scheduled_performing_physicians_name'
end
