require 'rails_helper'

describe 'POST /entries' do
  let(:mime_type) { 'application/pdf' }

  let(:headers) do
    {
      'Accept'       => 'text/plain',
      #'Content-Type' => 'application/json'
    }
  end

  context 'with valid params' do
    let(:params) do
      { entry: FactoryGirl.attributes_for(:entry) }
    end

    def do_post
      post '/entries', params, headers
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
    it 'returns HTTP status 422'
    it 'returns plain text'
    it 'does not save entry'
    it 'returns validation errors'
  end
end
