FactoryBot.define do
  factory :vote do
    positive { false }
    user { nil }
    votable { nil }
  end
end
