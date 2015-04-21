FactoryGirl.define do
  factory :station do
    name { Faker::Name.last_name.upcase }
    modality { %w(MR CT CR US MG).sample }
    aetitle { %w(PHILIPS SIEMENS AGFA).sample }
  end
end
