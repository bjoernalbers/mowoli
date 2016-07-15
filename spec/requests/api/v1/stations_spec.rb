require 'rails_helper'


def json
  @json ||= JSON.parse(response.body)
end

describe 'Stations APIv1' do
  let(:params)  { { } }
  let(:headers) { { 'Accept' => nil } }

  describe 'GET /api/v1/stations' do
    let!(:station) { FactoryGirl.create(:station) }

    before do
      get '/api/v1/stations', params, headers
    end

    it 'returns HTTP status 200' do
      expect(response.status).to eq 200
    end

    it 'returns stations in JSON' do
      expect(response.content_type).to be_json

      expect(json.size).to eq 1

      json_station = json.first
      expect(json_station['id']).to eq station.id
      expect(json_station['name']).to eq station.name
      expect(json_station['modality']).to eq station.modality.name
      expect(json_station['aetitle']).to eq station.aetitle
    end
  end
end
