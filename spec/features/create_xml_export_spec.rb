require 'rails_helper'

# In order to use dcm4chee as DCMMWL provider
# As a user
# I want to export my orders as XML.


feature 'Create XML export' do
  def xml_exports
    Dir.glob("#{Rails.configuration.worklist_dir}/*.xml")
  end

  scenario 'when order created' do
    expect(xml_exports).to be_empty

    order = FactoryGirl.create(:order)
    
    expect(xml_exports).to be_present

    xml_export = xml_exports.first
    content = File.read(xml_export)
    expect(content).to include order.accession_number

    order.destroy

    expect(xml_exports).to be_empty
  end
end
