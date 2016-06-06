FactoryGirl.define do
  factory :user do
    sequence(:first_name) do |n|
      "Bob#{n}"
    end
    sequence(:last_name) do |n|
      "Smith#{n}"
    end
    sequence(:email) do |n|
      "bobsmith#{n}@fake.com"
    end
    password "password"
    password_confirmation "password"

    after(:build) do |user|
      user.skip_confirmation!
    end
  end
end