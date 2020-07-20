module Votable
  extend ActiveSupport::Concern
  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def rating
    votes.reduce(0){|rating, vote| vote.positive ? rating += 1 : rating -= 1}
  end

  def votes_for
    votes.where(positive: true)
  end
end