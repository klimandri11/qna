FactoryBot.define do
  factory :question do
    sequence(:title) { |n| "Question title #{n}" }
    body { "MyText" }

    trait :invalid do
      title { nil }
    end
  end
end
