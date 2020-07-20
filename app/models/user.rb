# frozen_string_literal: true

class User < ApplicationRecord
  has_many :votes
  has_many :rewards
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def vote_for(votable)
    votes.create(votable: votable, positive: true)
  end

  def voted_for?(votable)
    votes.where(positive: true).map(&:votable).include?(votable)
  end

  def author_of?(object)
    id == object.user_id
  end
end
