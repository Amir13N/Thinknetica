FactoryBot.define do
  factory :answer do
    body { "AnswerText" }
    correct { false }
    question { Question.last }
    user { User.last }

    trait :invalid do
      body { nil }
    end
  end
end
