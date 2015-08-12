require 'rails_helper'

# As a user without a RIS
# I want to create orders from mowoli's build-in web UI.

feature 'Create orders' do
  scenario 'from default URL' do
    station = FactoryGirl.create(:station)

    visit '/orders/new'
    
    expect {
      fill_in 'Patienten-ID', with: '42'
      fill_in 'Name des Patienten', with: 'Norris^Chuck'
      fill_in 'Geburtsdatum des Patienten', with: '10.3.1940'
      choose 'männlich'
      fill_in 'Untersuchungsbeschreibung', with: 'Kniegelenk re.'
      fill_in 'Name des überweisenden Arztes', with: 'House^Gregory'
      fill_in 'Name des anfordernden Arztes', with: 'Dr. No' # kann später gelöscht werden!
      select station.name, from: 'Station'
      click_button 'Auftrag erstellen'
    }.to change(Order, :count).by(1)
    expect(page).to have_content('Norris')
  end

  after do
    # Clean up worklist files.
    Order.destroy_all
  end
end
