# frozen_string_literal: true

module Votable
  extend ActiveSupport::Concern
  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def rating
    votes.reduce(0) { |rating, vote| vote.positive ? rating += 1 : rating -= 1 }
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
    votes.map(&:user).include?(user)
  end

  private

  def voted_for?(user)
    votes.where(positive: true).map(&:user).include?(user)
  end

  def voted_against?(user)
    votes.where(positive: false).map(&:user).include?(user)
  end
end
