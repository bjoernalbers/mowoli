require 'rails_helper'

# As a user without a RIS
# I want to create orders from mowoli's build-in web UI.

feature 'Create orders' do
  scenario 'from default URL' do
    station = FactoryGirl.create(:station)

    visit '/orders/new'
    
    expect {
      within_fieldset 'Patient' do
        fill_in 'Vorname', with: 'Chuck'
        fill_in 'Nachname', with: 'Norris'
        fill_in 'Titel', with: 'Mr.'
        fill_in 'Geburtsdatum', with: '10.3.1940'
        choose 'männlich'
      end
      within_fieldset 'Überweisender Arzt' do
        fill_in 'Vorname', with: 'Gregory'
        fill_in 'Nachname', with: 'House'
        fill_in 'Titel', with: 'MD'
      end
      within_fieldset 'Untersuchung' do
        fill_in 'Untersuchungsbeschreibung', with: 'Kniegelenk re.'
        select station.name, from: 'Station'
      end
      click_button 'Auftrag erstellen'
    }.to change(Order, :count).by(1)
    expect(page).to have_content('Norris^Chuck^^Mr.')
    expect(page).to have_content('House^Gregory^^MD')

    order = Order.find_by(patients_name: 'Norris^Chuck^^Mr.')
    expect(order.patient_id).to match /^MOWOLI-\d+$/
  end

  after do
    # Remove all exports by destroying their orders.
    Order.destroy_all
  end
end
