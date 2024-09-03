FactoryBot.define do
  factory :event do
    name { Faker::Lorem.words(number: 3).join(' ') }
    location { Faker::Address.city }
    description { Faker::Lorem.paragraph }
    start_time { Faker::Date.forward(days: 23) }
    end_time { Faker::Date.forward(days: 30) }
  end
end
