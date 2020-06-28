# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    body { 'AnswerText' }
    question { Question.last }
    user { User.last }

    trait :invalid do
      body { nil }
    end
  end
end
