require 'rails_helper'

describe Order do
  let(:subject) { FactoryGirl.build(:order) }

  it 'has valid factory' do
    expect(subject).to be_valid
  end

  context 'on create' do
    it 'creates XML export' do
      xml_export = double('xml_export')
      allow(XMLExport).to receive(:new).and_return(xml_export)
      allow(xml_export).to receive(:create)

      subject = FactoryGirl.create(:order)

      expect(XMLExport).to have_received(:new).with(subject)
      expect(xml_export).to have_received(:create)
    end
  end

  context 'on destroy' do
    it 'creates XML export' do
      xml_export = double('xml_export')
      allow(XMLExport).to receive(:new).and_return(xml_export)
      allow(xml_export).to receive(:create)
      allow(xml_export).to receive(:delete)

      subject = FactoryGirl.create(:order)

      expect(XMLExport).to have_received(:new).with(subject)
      expect(xml_export).to have_received(:create)

      subject.destroy

      expect(xml_export).to have_received(:delete)
    end
  end

  describe '#station' do
    it 'is required' do
      subject = build(:order, station: nil)
      expect(subject).to be_invalid
      expect(subject.errors[:station]).to be_present
      expect{ subject.save(validate: false) }.to raise_error
    end
  end

  describe '#accession_number' do
    it 'returns id as string' do
      subject.id = 42
      expect(subject.accession_number).to eq '42'
    end
  end

  describe '#referring_physicians_name' do
    it 'is required' do
      subject.referring_physicians_name = nil
      expect(subject).not_to be_valid
      expect{ subject.save(validate: false) }.to raise_error
    end

    it 'contains max. 64 characters' do
      subject.referring_physicians_name = '0' * 65
      expect(subject).not_to be_valid
      subject.referring_physicians_name = '0' * 64
      expect(subject).to be_valid
    end
  end

  describe '#referring_physicians_name_attributes=' do
    it 'assigns referring_physicians_name' do
      subject.referring_physicians_name = nil
      subject.referring_physicians_name_attributes =
        { family: 'Norris', given: 'Chuck', prefix: 'Mr.' }
      expect(subject.referring_physicians_name).to eq 'Norris^Chuck^^Mr.'
    end
  end

  describe '#patients_name' do
    it 'is required' do
      subject.patients_name = nil
      expect(subject).not_to be_valid
      expect{ subject.save(validate: false) }.to raise_error
    end

    it 'contains max. 64 characters' do
      subject.patients_name = '0' * 65
      expect(subject).not_to be_valid
      subject.patients_name = '0' * 64
      expect(subject).to be_valid
    end
  end

  describe '#patients_name_attributes=' do
    it 'assigns patients_name' do
      subject.patients_name = nil
      subject.patients_name_attributes =
        { family: 'Norris', given: 'Chuck', prefix: 'Mr.' }
      expect(subject.patients_name).to eq 'Norris^Chuck^^Mr.'
    end
  end

  describe '#patient_id' do
    it 'is required' do
      subject.patient_id = nil
      expect(subject).not_to be_valid
      expect{ subject.save(validate: false) }.to raise_error
    end

    it 'contains max. 64 characters' do
      subject.patient_id = '0' * 65
      expect(subject).not_to be_valid
      subject.patient_id = '0' * 64
      expect(subject).to be_valid
    end
  end

  describe '#patients_birth_date' do
    it 'is required' do
      subject.patients_birth_date = nil
      expect(subject).not_to be_valid
      expect{ subject.save(validate: false) }.to raise_error
    end

    it 'returns a DICOM-conform representation' do
      subject.patients_birth_date = Date.new(2015, 5, 26)
      expect(subject.patients_birth_date.to_s(:dicom)).to eq '20150526'
    end
  end

  describe '#patients_sex' do
    it 'is required' do
      subject.patients_sex = nil
      expect(subject).not_to be_valid
      expect{ subject.save(validate: false) }.to raise_error
    end

    {
      'F' => 'Female',
      'M' => 'Male',
      'O' => 'Other'
    }.each do |code,description|
      it "can be '#{code}' (#{description})" do
        subject.patients_sex = code
        expect(subject).to be_valid
      end
    end

    it 'can not include other codes' do
      ['f', 'm', 'o', 'a', 'z', ',', '.', "\t", ' ', '-', 0, 9].each do |code|
        subject.patients_sex = code
        expect(subject).not_to be_valid
        expect(subject.errors[:patients_sex]).to be_present
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
      let(:subject) { FactoryGirl.build(:order, study_instance_uid: nil) }

      it 'assigns generated UID before validation' do
        expect(subject.study_instance_uid).to be nil
        subject.valid?
        expect(subject.study_instance_uid).to eq generated_uid
      end
    end

    context 'when set' do
      let(:custom_uid) { '1.23.567' }
      let(:subject) { FactoryGirl.build(:order, study_instance_uid: custom_uid) }

      it 'does not assign generated UID before validation' do
        expect(subject.study_instance_uid).to eq custom_uid
        subject.valid?
        expect(subject.study_instance_uid).to eq custom_uid
      end
    end

    it 'validates uniqueness' do
      other = FactoryGirl.create(:order, study_instance_uid: generated_uid)
      subject = FactoryGirl.build(:order, study_instance_uid: generated_uid)
      expect(subject).to be_invalid
      expect(subject.errors[:study_instance_uid]).to be_present
      expect{ subject.save!(validate: false) }.to raise_error
    end

    it 'validates length' do
      valid_uid = '1.2.' + '3' * 60
      subject = FactoryGirl.build(:order, study_instance_uid: valid_uid)
      expect(subject.study_instance_uid.size).to eq 64
      expect(subject).to be_valid

      too_long_uid = '1.2.' + '3' * 61
      subject = FactoryGirl.build(:order, study_instance_uid: too_long_uid)
      expect(subject.study_instance_uid.size).to eq 65
      expect(subject).to be_invalid
      expect(subject.errors[:study_instance_uid]).to be_present
    end

    it 'validates format' do
      uid = '1.2.3.45.67890'
      subject.study_instance_uid = uid
      expect(subject).to be_valid
      [
        'A', 'a', # No letters
        '_',      # No special characters
        #'.0123'   # No segment with leading zero #TODO Test this too!
      ].each do |invalid_suffix|
        subject.study_instance_uid = uid + invalid_suffix
        expect(subject).to be_invalid
      end
    end
  end

  describe '#requested_procedure_description' do
    it 'is required' do
      subject.requested_procedure_description = nil
      expect(subject).not_to be_valid
      expect{ subject.save(validate: false) }.to raise_error
    end
  end

  describe '#modality' do
    it 'returns modality from station' do
      subject = build(:order, station: nil)
      expect(subject.modality).to be nil

      station = create(:station, modality: 'DX')
      subject = build(:order, station: station)
      expect(subject.modality).to eq 'DX'
    end
  end

  describe '#scheduled_station_ae_title' do
    it 'returns aetitle from station' do
      subject = build(:order, station: nil)
      expect(subject.scheduled_station_ae_title).to be nil

      station = create(:station, aetitle: 'CHUNKY_BACON')
      subject = build(:order, station: station)
      expect(subject.scheduled_station_ae_title).to eq 'CHUNKY_BACON'
    end
  end

  describe '#scheduled_procedure_step_start_date'
    #it 'returns order creation date'

  describe '#scheduled_procedure_step_start_time'
    #it 'returns order creation time'

  describe '#scheduled_performing_physicians_name' do
    before do
      # Back up environment
      @scheduled_performing_physicians_name =
        ENV['SCHEDULED_PERFORMING_PHYSICIANS_NAME']
    end

    after do
      # Restore environment
      ENV['SCHEDULED_PERFORMING_PHYSICIANS_NAME'] =
        @scheduled_performing_physicians_name
    end

    it 'gets initialized from environment' do
      ENV['SCHEDULED_PERFORMING_PHYSICIANS_NAME'] = 'chunky^bacon'
      expect(subject.scheduled_performing_physicians_name).to eq 'chunky^bacon'
    end

    it 'is overwritable' do
      ENV['SCHEDULED_PERFORMING_PHYSICIANS_NAME'] = 'chunky^bacon'
      subject = build(:order, scheduled_performing_physicians_name: 'bacon')
      expect(subject.scheduled_performing_physicians_name).to eq 'bacon'
    end

    it 'validates presence' do
      subject = build(:order, scheduled_performing_physicians_name: nil)
      expect(subject.scheduled_performing_physicians_name).to be_nil
      expect(subject).to be_invalid
      expect(subject.errors[:scheduled_performing_physicians_name]).to be_present
    end

    it 'validates length' do
      subject = build(:order, scheduled_performing_physicians_name: 'x'*64)
      expect(subject).to be_valid

      subject = build(:order, scheduled_performing_physicians_name: 'x'*65)
      expect(subject).to be_invalid
      expect(subject.errors[:scheduled_performing_physicians_name]).to be_present
    end
  end

  describe '.purge_expired' do
    let(:now) { Time.zone.now }
    let(:subject) { build(:order) }

    it 'destroys orders since yesterday' do
      Timecop.freeze(now.beginning_of_day - 1.second) do
        subject.save!
      end
      described_class.purge_expired
      expect(described_class).not_to exist(subject.id)
    end

    it 'does not destroy orders from today' do
      Timecop.freeze(now.beginning_of_day) do
        subject.save!
      end
      described_class.purge_expired
      expect(described_class).to exist(subject.id)
    end
  end

  describe '#to_hl7' do
    let(:orm) { double('HL7::ORM', to_hl7: 'some fancy hl7') }
    before do
      allow(HL7::ORM).to receive(:new).and_return(orm)
    end

    it 'initializes HL7 ORM message with self' do
      subject.to_hl7
      expect(HL7::ORM).to have_received(:new).with(subject)
    end

    it 'exports HL7 ORM message' do
      expect(subject.to_hl7).to eq 'some fancy hl7'
    end
  end
end
