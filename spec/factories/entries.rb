FactoryGirl.define do
  factory :entry do
    accession_number { Faker::Number.number(10) }
    patient_id { Faker::Number.number(6) }
    patients_sex { Entry::PATIENTS_SEX_CODES.sample }
    patients_name { [ Faker::Name.last_name, Faker::Name.first_name ].join('^') }
    referring_physicians_name { [ Faker::Name.last_name, Faker::Name.first_name ].join('^') }
    requesting_physicians_name { [ Faker::Name.last_name, Faker::Name.first_name ].join('^') }
    requested_procedure_description { %w(head knee).sample }
    patients_birth_date { Faker::Date.between(90.years.ago, Date.today) }
    station
  end
end
