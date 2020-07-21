# frozen_string_literal: true

module Votable
  extend ActiveSupport::Concern
  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def rating
    votes.where(positive: true).count - votes.where(positive: false).count
  end

  def vote_for(user)
    votes.create(user: user, positive: true) unless voted?(user)
  end

  def vote_against(user)
    votes.create(user: user, positive: false) unless voted?(user)
  end

  def revote(user)
    votes.find_by(user: user)&.destroy
  end

  def voted?(user)
    votes.exists?(user: user)
  end

  private

  def voted_for?(user)
    votes.exists?(positive: true, user: user)
  end

  def voted_against?(user)
    votes.exists?(positive: false, user: user)
  end
end
