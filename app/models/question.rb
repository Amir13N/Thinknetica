class Question < ApplicationRecord

  has_many :answers

  validates :body, :title, presence: true
  validates :body, uniqueness: { scope: :title }

end
