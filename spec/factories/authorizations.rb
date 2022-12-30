FactoryBot.define do
  factory :authorization do
    user { nil }
    provider { 'github' }
    uid { 'MyString' }
  end
end
