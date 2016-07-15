FactoryGirl.define do
  factory :modality do
    name        { ('A'..'Z').to_a.sample(10).join }
    description { Faker::Commerce.product_name }
  end
end
