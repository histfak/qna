FactoryBot.define do
  factory :vote do
    score { 1 }
    user
    for_question

    trait :for_question do
      association(:votable, factory: :question)
    end
  end
end
