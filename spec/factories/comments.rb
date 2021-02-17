# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    body
    commentable { FactoryBot.create(:question) }
    user

    trait :invalid do
      body { nil }
    end
  end
end
