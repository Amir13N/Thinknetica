# frozen_string_literal: true

FactoryBot.define do
  sequence :title do |n|
    "title#{n}"
  end

  factory :question do
    title
    body { 'QuestionText' }
    user

    trait :invalid do
      title { nil }
    end

    trait :with_file do
      after :create do |question|
        file_path = Rails.root.join('spec/rails_helper.rb')
        file = fixture_file_upload(file_path, 'ruby')
        question.files.attach(file)
      end
    end
  end
end
