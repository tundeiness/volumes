FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    contact_number { Faker::PhoneNumber.phone_number }
    address { Faker::Address.full_address }
    username { Faker::Internet.username }
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }
    gender { Faker::Gender }

    trait :admin do
      role { :admin }
    end

    trait :therapist do
      role { :therapist }
    end

    trait :client do
      role { :client }
    end
  end
end
