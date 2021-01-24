# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user

    if @user
      @user.admin? ? admin_abilities : user_abilities
    else
      quest_abilities
    end
  end

  def quest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    quest_abilities
    can :create, [Question, Answer, Comment]
    can %i[update delete], [Question, Answer], user_id: @user.id

    can :vote, [Question, Answer]
    cannot :vote, Votable, user_id: @user.id

    can :make_the_best, Answer
    cannot :make_the_best, Answer, user_id: @user.id

    can :add_comment, Answer

    can :delete_attachment, [Question, Answer], user_id: @user.id
  end
end
