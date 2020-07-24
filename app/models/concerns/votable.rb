# frozen_string_literal: true

module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def rating
    votes.sum(:rate)
  end

  def vote_for(user)
    votes.create(user: user, rate: 1) unless voted?(user)
  end

  def vote_against(user)
    votes.create(user: user, rate: -1) unless voted?(user)
  end

  def revote(user)
    votes.find_by(user: user)&.destroy
  end

  def voted?(user)
    votes.exists?(user: user)
  end
end
