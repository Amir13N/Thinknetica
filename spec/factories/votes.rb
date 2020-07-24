# frozen_string_literal: true

FactoryBot.define do
  factory :vote do
    positive { false }
    user
  end
end
