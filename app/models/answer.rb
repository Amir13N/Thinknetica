# frozen_string_literal: true

class Answer < ApplicationRecord
  include Linkable
  include Votable
  include Commentable

  belongs_to :question
  belongs_to :user

  has_many_attached :files

  validates :body, presence: true
  validate :best_answer_presence, unless: -> { question.nil? }

  after_create :notify_question_subscribers

  def make_best
    ActiveRecord::Base.transaction do
      question.best_answer&.update!(best: false)
      update!(best: true)
      question.reward&.update!(user: user)
    end
  end

  private

  def notify_question_subscribers
    AnswerNotifyJob.perform_later(self)
  end

  def best_answer_presence
    if question.best_answer && best && question.best_answer != self
      errors.add(:question, 'can only have one best answer')
    end
  end
end
