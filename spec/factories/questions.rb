FactoryBot.define do
  factory :question do
    title { "MyQuestionString" }
    body { "MyQuestionText" }
    association :author, factory: :user

    trait :invalid do
      title { nil }
    end
  end
end
