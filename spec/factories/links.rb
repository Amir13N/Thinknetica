# frozen_string_literal: true

FactoryBot.define do
  factory :link do
    name { 'link' }
    url { 'http://url' }
    linkable { FactoryBot.create(:question) }
  end
end
