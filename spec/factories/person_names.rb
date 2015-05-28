FactoryGirl.define do
  factory :person_name do
    family { Faker::Name.last_name }
    given  { Faker::Name.first_name }

    factory :full_person_name do
      middle { Faker::Name.first_name }
      prefix { Faker::Name.prefix }
      suffix { Faker::Name.suffix }
    end
  end
end
