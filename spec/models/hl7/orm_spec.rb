require 'rails_helper'

module HL7
  describe ORM do
    let(:segments) { %w(msh pid pv1 orc obr) }
    #let(:order) { build(:order) } # NOTE: Unsaved orders don't have a study instance uid.
    let(:order) { create(:order) }
    let(:subject) { described_class.new(order) }

    let(:msh) { subject.msh }
    let(:pid) { subject.pid }
    let(:pv1) { subject.pv1 }
    let(:orc) { subject.orc }
    let(:obr) { subject.obr }

    it 'MSH-2 returns constant' do
      expect(msh.encoding_characters).to eq '^~\&'
    end

    it 'MSH-3 returns constant' do
      expect(msh.sending_application).to eq 'Mowoli'
    end

    it 'MSH-4 returns constant' do
      expect(msh.sending_facility).to eq(
        'Radiologische Gemeinschaftspraxis im Evangelischen Krankenhaus Lippstadt')
    end

    it 'MSH-5 returns constant' do
      expect(msh.receiving_application).to eq 'Cloverleaf'
    end

    it 'MSH-6 returns constant' do
      expect(msh.receiving_facility).to eq 'EVK Lippstadt'
    end

    it 'MSH-7 returns current time' do
      time = Time.zone.now-1.week
      Timecop.freeze(time) do
        expect(msh.datetime_of_message).to eq time
      end
    end

    it 'MSH-9 returns constant' do
      expect(msh.message_type).to eq 'ORM^O01^ORM_O01'
    end

    it 'MSH-10 returns random hex string' do
      expect(msh.message_control_id).to match /^[0-9a-f]{20}$/
      other = described_class.new(order)
      expect(msh.message_control_id).not_to eq other.msh.message_control_id
    end

    it 'MSH-12 returns constant' do
      expect(msh.version_id).to eq '2.3'
    end

    it 'PID-3 returns patient id' do
      expect(pid.internal_patient_id).to eq order.patient_id
    end

    it 'PID-5 returns patients name' do
      expect(pid.patient_name).to eq order.patients_name
    end

    it 'PID-7 returns patients birth date' do
      expect(pid.date_of_birth).to eq order.patients_birth_date.to_datetime
    end

    it 'PID-8 returns patients sex' do
      expect(pid.sex).to eq order.patients_sex
    end

    it 'PV1-2 returns constant' do
      expect(pv1.patient_class).to eq 'U'
    end

    it 'PV1-8 returns referring physicians name' do
      expect(pv1.referring_doctor).to eq order.referring_physicians_name
    end

    it 'ORC-1 returns constant' do
      expect(orc.order_control).to eq 'NW'
    end

    it 'ORC-2 returns accession number' do
      expect(orc.placer_order_number).to eq order.accession_number
    end

    it 'ORC-3 returns study instance uid' do
      expect(orc.filler_order_number).to eq('^^' + order.study_instance_uid)
    end

    it 'ORC-9 returns creation date' do
      time = Time.zone.now-2.weeks
      order.created_at = time
      Timecop.freeze(time) do
        expect(orc.datetime_of_transaction).to eq time
      end
    end

    it 'OBR-18 returns accession number' do
      expect(obr.placer_field_1).to eq order.accession_number
    end

    it 'OBR-21 returns constant' do
      expect(obr.filler_field_2).to eq 'DL1'
    end

    it 'OBR-24 returns aetitle' do
      expect(obr.diagnostic_serv_sect_id).to eq order.scheduled_station_ae_title
    end

    it 'OBR-34 returns scheduled performing physicians name' do
      expect(obr.technician).to eq order.scheduled_performing_physicians_name
    end

    it 'OBR-44 returns requested procedure description' do
      expect(obr.procedure_code).to eq('^^^^' + order.requested_procedure_description)
    end

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
end
