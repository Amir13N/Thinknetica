# frozen_string_literal: true

FactoryBot.define do
  sequence :body do |n|
    "AnswerText#{n}"
  end

  factory :answer do
    body
    question
    user

    trait :invalid do
      body { nil }
    end

    trait :with_file do
      after :create do |answer|
        file_path = Rails.root.join('spec/rails_helper.rb')
        file = fixture_file_upload(file_path, 'ruby')
        answer.files.attach(file)
      end
    end
  end
end
