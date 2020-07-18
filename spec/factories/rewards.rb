# frozen_string_literal: true

FactoryBot.define do
  factory :reward do
    title
    picture { 'MyString' }
    question
  end
end
