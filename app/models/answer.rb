# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  has_many_attached :files

  validates :body, presence: true
  validate :best_answer_presence, unless: -> { question.nil? }

  def make_best
    ActiveRecord::Base.transaction do
      question.best_answer&.update!(best: false)
      update!(best: true)
    end
  end

  private

  def best_answer_presence
    if question.best_answer && best && question.best_answer != self
      errors.add(:question, 'can only have one best answer')
    end
  end
end
