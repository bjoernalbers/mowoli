#require 'spec_helper'
require 'rails_helper'

# In order know which orders are created
# As a user
# I want to view orders

feature 'View orders' do
  scenario 'on landing page' do
    order = FactoryGirl.create(:order)
    visit root_url
    expect(page).to have_content(order.patients_name)
  end
end
