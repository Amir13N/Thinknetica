class Question < ApplicationRecord

  has_many :answers

  validates :body, :title, presence: true, uniqueness: true

end
