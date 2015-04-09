#require 'spec_helper'
require 'rails_helper'

# In order know which entries are created
# As a user
# I want to view entries

feature 'View entries' do
  scenario 'on landing page' do
    entry = FactoryGirl.create(:entry)
    visit root_url
    expect(page).to have_content(entry.patients_name)
  end
end
