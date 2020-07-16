# frozen_string_literal: true

class Question < ApplicationRecord
  belongs_to :user

  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  validates :body, :title, presence: true
  validates :body, uniqueness: { scope: :title }

  accepts_nested_attributes_for :links, reject_if: :all_blank

  def best_answer
    answers.find_by(best: true)
  end
end
