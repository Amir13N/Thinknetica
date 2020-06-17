class Question < ApplicationRecord
  has_many :answers, dependent: :destroy

  validates :body, :title, presence: true
  validates :body, uniqueness: { scope: :title }
end
