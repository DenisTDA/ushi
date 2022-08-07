FactoryBot.define do
  sequence(:user) { |n| "user#{n}" }
  
  factory :user do
    email { "#{user}@test.com" }
    password { '12345678' }
  end
end
