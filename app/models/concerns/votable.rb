# frozen_string_literal: true

module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def rating
    vote_rates.compact.sum
  end

  def vote_for(user)
    unless voted?(user)
      vote = votes.create(user: user, positive: true)
      vote_rates[vote.id] = 1
      save
    end
  end

  def vote_against(user)
    unless voted?(user)
      vote = votes.create(user: user, positive: false)
      vote_rates[vote.id] = -1
      save
    end
  end

  def revote(user)
    vote = votes.find_by(user: user)&.destroy
    vote_rates[vote.id] = nil
    save
  end

  def voted?(user)
    votes.exists?(user: user)
  end
end
