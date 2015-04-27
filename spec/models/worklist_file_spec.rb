require 'rails_helper'

describe WorklistFile do
  let(:entry) { double('entry') }
  let(:worklist_file) { WorklistFile.new(entry) }

  before do
    allow(entry).to receive(:study_instance_uid) { '1.23.456' }
  end

  describe '#create' do
    it 'creates worklist file'
  end

  describe '#delete' do
    context 'when created' do
      before do
        allow(worklist_file).to receive(:created?) { true }
        allow(FileUtils).to receive(:rm)
      end

      it 'deletes worklist file' do
        worklist_file.delete
        expect(FileUtils).to have_received(:rm).with(worklist_file.path)
      end
    end

    context 'when not created' do
      before do
        allow(worklist_file).to receive(:created?) { false }
      end

      it 'does not raise error' do
        expect{ worklist_file.delete }.not_to raise_error
      end
    end
  end

  describe '#content' do
    let(:entries_controller) { double('entries_controller') }

    before do
      allow(EntriesController).to receive(:new) { entries_controller }
      allow(entries_controller).to receive(:render_to_string)
    end

    it 'renders entries template to string' do
      worklist_file.content
      expect(entries_controller).to have_received(:render_to_string).
        with('show.xml', locals: { entry: entry })
    end

    it 'returns rendered string' do
      allow(entries_controller).to receive(:render_to_string) { 'chunky bacon' }
      expect(worklist_file.content).to eq 'chunky bacon'
    end
  end

  describe '#path' do
    it 'returns path to worklist file' do
      expect(worklist_file.path).to eq "#{Rails.configuration.worklist_dir}/1.23.456.xml"
    end
  end
end
