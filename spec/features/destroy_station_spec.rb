require 'rails_helper'

feature 'Destroy station' do
  scenario 'via Web-UI' do
    station = FactoryGirl.create(:station)

    visit '/stations'

    expect {
      click_link 'Destroy'
    }.to change(Station, :count).by(-1)
  end
end
