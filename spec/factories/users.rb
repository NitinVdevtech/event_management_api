FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { 'password' }
    admin { false }

    trait :admin do
      admin { true }
    end
  end
end
