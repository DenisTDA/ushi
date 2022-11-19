FactoryBot.define do
  factory :vote do
    for_question # default to the :for_photo trait if none is specified

    trait :for_question do
      association :voteable, factory: :question
      useful { false }
      voter  { nil }
    end

    trait :for_answer do
      association :voteable, factory: :answer
      useful { true }
      voter  { nil }
    end
  end
end
