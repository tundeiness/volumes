FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }

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
