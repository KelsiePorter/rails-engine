FactoryBot.define do
  factory :item do
    name { Faker::Commerce.product_name }
    description { Faker::Lorem.paragraph }
    unit_price { Faker::Commerce.price }
    merchant_id { Faker::Number.within(range: 1..10) }
  end
end
