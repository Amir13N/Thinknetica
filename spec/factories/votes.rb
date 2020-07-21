# frozen_string_literal: true

FactoryBot.define do
  factory :vote do
    positive { false }
    user
    votable { question }
  end
end
