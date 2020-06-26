FactoryBot.define do
  sequence :title do |n|
    "title#{n}"
  end

  factory :question do
    title
    body { "QuestionText" }
    user { User.last }

    trait :invalid do
      title { nil }
    end
  end
end
