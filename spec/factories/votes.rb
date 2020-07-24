# frozen_string_literal: true

FactoryBot.define do
  factory :vote do
    rate { 1 }
    user
  end
end
