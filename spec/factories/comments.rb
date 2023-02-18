FactoryBot.define do
  factory :comment do
    body { 'Comment_body' }
  end

  trait :invalid_comment do
    body { nil }
  end
end
