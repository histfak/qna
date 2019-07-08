FactoryBot.define do
  factory :reward do
    user { nil }
    title { 'RewardTestTitle ' }
    question
    badge { fixture_file_upload("#{Rails.root}/public/badge.png", 'image/png') }
  end
end
