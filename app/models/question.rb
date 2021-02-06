# frozen_string_literal: true

class Question < ApplicationRecord
  include Linkable
  include Votable
  include Commentable

  belongs_to :user

  has_and_belongs_to_many :subscribers, as: :subscribe, class_name: 'User'

  has_one :reward, dependent: :destroy
  has_many :answers, dependent: :destroy

  has_many_attached :files

  validates :body, :title, presence: true
  validates :body, uniqueness: { scope: :title }

  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true

  after_create :subscribe_author

  def best_answer
    answers.find_by(best: true)
  end

  def subscribe(subscriber)
    subscribers.push(subscriber) unless subscribed?(subscriber)
  end

  def unsubscribe(subscriber)
    subscribers.delete(subscriber)
  end

  def subscribed?(subscriber)
    subscribers.include?(subscriber)
  end

  private

  def subscribe_author
    subscribe(user)
  end
end
