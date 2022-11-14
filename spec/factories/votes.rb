FactoryBot.define do
  factory :vote do
    voter { nil }
    voteable { nil }
    useful { false }
  end
end
