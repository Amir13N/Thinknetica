FactoryBot.define do
  factory :link do
    name { "MyString" }
    url { "MyString" }
    linkable { create(:question) }
  end
end
