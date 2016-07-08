require 'rails_helper'

# In order to forward orders to other facilities
# As a user
# I want to export my orders as HL7.

feature 'Create HL7 export' do
  def hl7_exports
    Dir.glob("#{Rails.configuration.hl7_export_dir}/*.hl7")
  end

  scenario 'when order created' do
    expect(hl7_exports).to be_empty

    station = FactoryGirl.create(:station, receives_orders_via_hl7: true)
    order = FactoryGirl.create(:order, station: station)
    
    expect(hl7_exports).to be_present

    hl7_export = hl7_exports.first
    content = File.read(hl7_export)
    expect(content).to include order.accession_number
    expect(content).to include order.study_instance_uid

    order.destroy

    expect(hl7_exports).to be_empty
  end
end
