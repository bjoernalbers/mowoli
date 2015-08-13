require 'rails_helper'

RSpec.describe OrdersController, type: :controller do

  describe 'GET #index' do
    #TODO: Delete!
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #new' do
    #TODO: Delete!
    it 'returns http success' do
      get :new
      expect(response).to have_http_status(:success)
    end

    it 'assigns new order' do
      get :new
      expect(assigns(:order)).to be_present
      expect(assigns(:order)).to be_new_record
    end
  end

  describe 'POST #create' do
    def do_post
      post :create, order: order_params
    end

    context 'with valid attributes' do
      let(:order_params) do
        p = build(:order).attributes.symbolize_keys.
          reject { |k,v| [:id, :created_at, :updated_at, :patient_id].include? k }
        [
          :patients_name_attributes,
          :referring_physicians_name_attributes
        ].each { |attr| p[attr] = FactoryGirl.attributes_for(:person_name) }
        p
      end


      it 'creates order' do
        expect{ do_post }.to change(Order, :count).by(1)
      end

      it 'assigns order' do
        do_post
        expect(assigns(:order)).to be_present
      end

      it 'redirects to order' do
        do_post
        expect(response).to redirect_to order_path(assigns(:order))
      end

      it 'assigns random patient_id'
    end

    context 'with invalid attributes' do
      # NOTE: This returns invalid attributes since station id is missing,
      # hence the workarount for valid attributes (see above).
      let(:order_params) { attributes_for(:order) } 

      it 'creates no order' do
        expect{ do_post }.to change(Order, :count).by(0)
      end

      it 'assigns order' do
        do_post
        expect(assigns(:order)).to be_present
      end

      it 'renders new template' do
        do_post
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #show' do
    let(:order) { create(:order) }

    before do
      get :show, id: order
    end

    it 'assigns order' do
      expect(assigns(:order)).to eq order
    end

    it 'renders show template' do
      expect(response).to render_template :show
    end
  end
end
