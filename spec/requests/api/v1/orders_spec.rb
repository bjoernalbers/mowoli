require 'rails_helper'


def json
  @json ||= JSON.parse(response.body)
end

describe 'Orders APIv1' do
  let(:headers) { { 'Accept' => nil } }
  let(:params)  { { } }

  describe 'POST /api/v1/orders' do
    def do_post
      post '/api/v1/orders', params, headers
    end

    context 'with valid params' do
      before do
        pending 'FIX busted params'
      end

      let!(:station) { FactoryGirl.create(:station) }
      let(:params) do
        { order: FactoryGirl.build(:order).attributes.compact }
      end

      it 'returns HTTP status 201' do
        do_post
        expect(response.status).to eq 201
      end

      it 'sets location header' do
        do_post
        expect(response.location).to eq api_v1_order_url(Order.last)
      end

      it 'returns order in JSON' do
        do_post
        expect(response.content_type).to be_json
        expect(response).to render_template(:show)
      end

      it 'creates order' do
        expect{ do_post }.to change(Order, :count).by(1)
      end
    end

    context 'with existing accession number' do
      let!(:order) { FactoryGirl.create(:order) }
      let(:station) { FactoryGirl.create(:station) }
      let(:params) do
        { order: FactoryGirl.build(:order, accession_number: order.accession_number).attributes.compact }
      end

      it 'returns HTTP status 201' do
        do_post
        expect( response.status ).to eq 201
      end

      it 'creates no order' do
        expect{ do_post }.to change(Order, :count).by(0)
      end
    end

    context 'with invalid params' do
      let(:params) do
        { order: FactoryGirl.attributes_for(:order) }
      end

      it 'returns HTTP status 422' do
        do_post
        expect( response.status ).to eq 422
      end

      it 'creates no order' do
        expect{ do_post }.to change(Order, :count).by(0)
      end

      it 'returns validation errors' do
        do_post
        expect(json['errors']).to be_present
      end
    end
  end


  describe 'GET /api/v1/orders/:id' do
    let(:order) { FactoryGirl.create(:order) }

    context 'when order found' do
      before do
        get "/api/v1/orders/#{order.id}", params, headers
      end

      it 'returns HTTP status 200' do
        expect(response.status).to eq 200
      end

      it 'returns order in JSON' do
        expect(response.content_type).to be_json

        # Basics
        expect(json['id']).to eq order.id
        expect(json['accession_number']).to eq order.accession_number
        expect(json['study_instance_uid']).to eq order.study_instance_uid

        # Patient
        expect(json['patient_id']).to eq order.patient_id
        expect(json['patients_name']).to eq order.patients_name
        expect(json['patients_birth_date']).to eq order.patients_birth_date.iso8601
        expect(json['patients_sex']).to eq order.patients_sex

        # Station
        expect(json['station']['id']).to eq order.station.id
        expect(json['station']['name']).to eq order.station.name
        expect(json['station']['modality']).to eq order.station.modality
        expect(json['station']['aetitle']).to eq order.station.aetitle
      end
    end

    context 'when order not found' do
      before do
        get '/api/v1/orders/42', params, headers
      end

      it 'returns HTTP status 404' do
        expect(response.status).to eq 404
      end

      it 'returns no body' do
        expect(response.body.strip).to be_empty
      end
    end
  end

  describe 'DELETE /api/v1/orders/:id' do
    context 'when order found' do
      let!(:order) { FactoryGirl.create(:order) }

      def do_delete
        delete "/api/v1/orders/#{order.id}", headers
      end

      it 'deletes order' do
        expect{ do_delete }.to change(Order, :count).by(-1)
      end

      it 'returns HTTP status 204' do
        do_delete
        expect(response.status).to eq 204
      end

      it 'returns no body' do
        do_delete
        expect(response.body.strip).to be_empty
      end
    end

    context 'when order not found' do
      def do_delete
        delete '/api/v1/orders/42', headers
      end

      it 'deletes no order' do
        expect{ do_delete }.to change(Order, :count).by(0)
      end

      it 'returns HTTP status 404' do
        do_delete
        expect(response.status).to eq 404
      end

      it 'returns no body' do
        do_delete
        expect(response.body.strip).to be_empty
      end
    end
  end
end
