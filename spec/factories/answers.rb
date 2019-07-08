FactoryBot.define do
  factory :answer do
    body { "MyAnswerText" }
    question
    association :author, factory: :user

    trait :invalid do
      body { nil }
    end

    trait :with_links do
      after :create do |answer|
        create :link, linkable: answer, url: 'http://google.com'
      end
    end

    trait :with_files do
      files { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb", 'text/plain') }
    end
  end
end
