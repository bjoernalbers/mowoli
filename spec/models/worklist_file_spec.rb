require 'rails_helper'

describe WorklistFile do
  let(:order) { double('order') }
  let(:worklist_file) { WorklistFile.new(order) }

  before do
    allow(order).to receive(:study_instance_uid) { '1.23.456' }
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
    let(:orders_controller) { double('orders_controller') }

    before do
      allow(OrdersController).to receive(:new) { orders_controller }
      allow(orders_controller).to receive(:render_to_string)
    end

    it 'renders orders template to string' do
      worklist_file.content
      expect(orders_controller).to have_received(:render_to_string).
        with('show.xml', locals: { order: order })
    end

    it 'returns rendered string' do
      allow(orders_controller).to receive(:render_to_string) { 'chunky bacon' }
      expect(worklist_file.content).to eq 'chunky bacon'
    end
  end

  describe '#path' do
    it 'returns path to worklist file' do
      expect(worklist_file.path).to eq "#{Rails.configuration.worklist_dir}/1.23.456.xml"
    end
  end
end
