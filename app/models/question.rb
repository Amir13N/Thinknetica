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

  def best_answer
    answers.find_by(best: true)
  end
end
