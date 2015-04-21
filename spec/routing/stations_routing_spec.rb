require "rails_helper"

RSpec.describe StationsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/stations").to route_to("stations#index")
    end

    it "routes to #new" do
      expect(:get => "/stations/new").to route_to("stations#new")
    end

    it "routes to #show" do
      expect(:get => "/stations/1").to route_to("stations#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/stations/1/edit").to route_to("stations#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/stations").to route_to("stations#create")
    end

    it "routes to #update" do
      expect(:put => "/stations/1").to route_to("stations#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/stations/1").to route_to("stations#destroy", :id => "1")
    end

  end
end
