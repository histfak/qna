FactoryBot.define do
  factory :question do
    # title { "MyQuestionString" }
    sequence :title do |n|
      "MyQuestionString #{n}"
    end
    body { "MyQuestionText" }
    association :author, factory: :user

    trait :invalid do
      title { nil }
    end

    trait :with_links do
      after :create do |question|
        create :link, linkable: question
      end
    end

    trait :with_reward do
      after :create do |question|
        create :reward, title: 'You are the best!', question: question,
                        badge: fixture_file_upload("#{Rails.root}/public/badge.png", 'image/png')
      end
    end

    trait :with_files do
      files { fixture_file_upload("#{Rails.root}/spec/spec_helper.rb", 'text/plain') }
    end
  end
end
