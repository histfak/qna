FactoryBot.define do
  factory :question do
    title { "MyQuestionString" }
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

    trait :with_files do
      files { fixture_file_upload("#{Rails.root}/spec/spec_helper.rb", 'text/plain') }
    end
  end
end
