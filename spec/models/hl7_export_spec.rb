require 'rails_helper'

describe HL7Export do
  let(:content) { 'some fancy HL7' }
  let(:order) { double('order', id: 42) }
  let(:subject) { described_class.new(order) }

  context 'on initialize' do
    it 'raises error with blank :dir' do
      [ '', nil ].each do |dir|
        expect{
          described_class.new(order, dir: dir)
        }.to raise_error(ExportError, /no export directory configured/i)
      end
    end

    it 'raises error when :dir is no directory' do
      dir = 'chunky bacon'
      expect{
        described_class.new(order, dir: dir)
      }.to raise_error(ExportError, /"chunky bacon" is no directory/i)
    end
  end

  describe '#create' do
    before do
      allow(subject).to receive(:content) { content }
    end

    it 'writes content to file' do
      subject.create
      file_content = File.read(subject.path)
      expect(file_content).to eq content
    end

    it 'raises error when order has no id' do
      allow(order).to receive(:id) { nil }
      expect{ subject.create }.to raise_error(ExportError)
    end

    it 'raises error when file write fails' do
      [
        Errno::ENOENT,
        Errno::EACCES
      ].each do |exception|
        allow(File).to receive(:open) { raise exception }
        expect{ subject.create }.to raise_error(ExportError)
      end
    end
  end

  describe '#delete' do
    let(:path) { double(:path) }

    before do
      allow(path).to receive(:delete)
      allow(subject).to receive(:path) { path }
    end

    it 'deletes file when present' do
      allow(path).to receive(:exist?) { true }
      subject.delete
      expect(path).to have_received(:delete)
    end

    it 'does not delete file when missing' do
      allow(path).to receive(:exist?) { false }
      subject.delete
      expect(path).not_to have_received(:delete)
    end
  end

  describe '#path' do
    it 'returns file path' do
      expect(subject.path.to_s).to eq(
        "#{Rails.configuration.hl7_export_dir}/#{order.id}.hl7")
    end
  end

  describe '#content' do
    let(:orm) { double('HL7::ORM', to_hl7: content) }

    before do
      allow(HL7::ORM).to receive(:new).and_return(orm)
    end

    it 'initializes HL7 ORM message with order' do
      subject.content
      expect(HL7::ORM).to have_received(:new).with(order)
    end

    it 'returns HL7 ORM content' do
      expect(subject.content).to eq content
    end
  end

  describe '#dir' do
    context 'with default dir' do
      let(:dir) { Rails.configuration.hl7_export_dir }

      it 'returns dir' do
        expect(subject.dir).to eq dir
      end
    end

    context 'with custom dir' do
      let(:dir) { Dir.mktmpdir }
      let(:subject) { described_class.new(order, dir: dir) }

      it 'returns dir' do
        expect(subject.dir).to eq dir
      end
    end
  end
end
