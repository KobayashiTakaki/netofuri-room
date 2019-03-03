FactoryBot.define do
  factory :user do
    name { "testuser" }
    password { "password" }
    password_confirmation { "password" }
  end
end
