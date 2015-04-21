require 'rails_helper'

describe 'POST /entries' do
  let(:mime_type) { 'application/pdf' }

  let(:headers) do
    {
      'Accept'       => 'text/plain',
      #'Content-Type' => 'application/json'
    }
  end

  def do_post
    post '/entries', params, headers
  end

  context 'with valid params send twice' do
    let(:station) { FactoryGirl.create(:station) }
    let(:params) do
      p = { entry: FactoryGirl.attributes_for(:entry) }
      p[:entry][:station_name] = station.name
      p
    end

    before do
      do_post
    end

    it 'returns HTTP status 201' do
      do_post
      expect( response.status ).to eq 201
    end

    it 'does not create new entry' do
      expect{ do_post }.to change(Entry, :count).by(0)
    end
  end

  context 'with valid params' do
    let(:station) { FactoryGirl.create(:station) }
    let(:params) do
      p = { entry: FactoryGirl.attributes_for(:entry) }
      p[:entry][:station_name] = station.name
      p
    end

    it 'returns HTTP status 201' do
      do_post
      expect( response.status ).to eq 201
    end

    it 'returns plain text' do
      do_post
      expect( response.content_type ).to be_text
    end

    it 'creates new entry' do
      expect{ do_post }.to change(Entry, :count).by(1)
    end
  end

  context 'with invalid params' do
    let(:params) do
      { entry: FactoryGirl.attributes_for(:entry) }
    end

    it 'returns HTTP status 422' do
      do_post
      expect( response.status ).to eq 422
    end

    it 'returns plain text' do
      do_post
      expect( response.content_type ).to be_text
    end

    it 'does not create new entry' do
      expect{ do_post }.to change(Entry, :count).by(0)
    end

    it 'returns validation errors'
  end
end
