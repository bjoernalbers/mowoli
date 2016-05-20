require 'rails_helper'
require 'active_attr/rspec'

describe ZDS do
  let(:subject) { described_class.new }

  it 'includes all fields' do
    expect(subject.field_names).to eq [
      :study_instance_uid
    ]
  end
end
