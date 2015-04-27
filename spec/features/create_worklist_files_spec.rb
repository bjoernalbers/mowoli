require 'rails_helper'

# In order ship the worklist via dcm4che's dcmof
# As a user
# I want to serialize my entries as worklist files


feature 'Create worklist files' do
  def worklist_files
    Dir.glob("#{Rails.configuration.worklist_dir}/*.xml")
  end

  scenario 'when entry created' do
    expect(worklist_files).to be_empty

    entry = FactoryGirl.create(:entry)
    
    expect(worklist_files).to be_present

    worklist_file = worklist_files.first
    content = File.read(worklist_file)
    expect(content).to include entry.accession_number

    entry.destroy

    expect(worklist_files).to be_empty
  end
end
