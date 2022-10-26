FactoryBot.define do
  factory :question do
    title { 'MyString' }
    body { 'MyText' }
    association :author, factory: :user

    trait :invalid do
      title { nil }
      body { nil }
    end
  end
end
