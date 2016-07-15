require 'rails_helper'

feature 'Create station' do
  let(:attributes) { FactoryGirl.attributes_for(:station) }
  let!(:modality) { FactoryGirl.create(:modality) }

  scenario 'via Web-UI' do
    visit root_url
    click_link 'Stations'
    click_link 'New Station'

    expect {
      fill_in 'Name', with: attributes[:name]
      fill_in 'Aetitle', with: attributes[:aetitle]
      #select modality.name, from: 'Modalität' # ...does not work?!
      within '#station_modality_id' do
        select modality.name
      end
      check 'Empfängt Aufträge per HL7?'
      select 'ISO_IR 192', from: 'Zeichensatz'
      click_button 'Station erstellen'
    }.to change(Station, :count).by(1)

    station = Station.last
    expect(station.name).to eq attributes[:name]
    expect(station.modality).to eq modality
    expect(station.aetitle).to eq attributes[:aetitle]
    expect(station.receives_orders_via_hl7).to be_truthy
    expect(station.character_set).to eq 'ISO_IR 192'
  end
end
