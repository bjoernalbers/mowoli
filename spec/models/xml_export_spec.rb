require 'rails_helper'

describe XMLExport do
  let(:order) { double('order') }
  let(:subject) { described_class.new(order) }

  before do
    allow(order).to receive(:id) { 42 }
  end

  describe '#create' do
    it 'creates XML export'
  end

  describe '#delete' do
    context 'when created' do
      before do
        allow(subject).to receive(:created?) { true }
        allow(FileUtils).to receive(:rm)
      end

      it 'deletes XML export' do
        subject.delete
        expect(FileUtils).to have_received(:rm).with(subject.path)
      end
    end

    context 'when not created' do
      before do
        allow(subject).to receive(:created?) { false }
      end

      it 'does not raise error' do
        expect{ subject.delete }.not_to raise_error
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
      subject.content
      expect(orders_controller).to have_received(:render_to_string).
        with('show.xml', locals: { order: order })
    end

    it 'returns rendered string' do
      allow(orders_controller).to receive(:render_to_string) { 'chunky bacon' }
      expect(subject.content).to eq 'chunky bacon'
    end
  end

  describe '#path' do
    it 'returns file path' do
      expect(subject.path).to eq "#{Rails.configuration.worklist_dir}/#{order.id}.xml"
    end
  end
end
