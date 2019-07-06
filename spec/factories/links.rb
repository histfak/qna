FactoryBot.define do
  factory :link do
    sequence :name do |n|
      "Link #{n}"
    end
    url { "MyString" }
  end
end
