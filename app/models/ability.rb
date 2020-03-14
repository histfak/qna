# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  private

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Subscription]
    can :update, [Question, Answer], user_id: user.id
    can :destroy, [Question, Answer, Subscription], user_id: user.id
    can :create_comment, [Question, Answer]

    can :destroy, ActiveStorage::Attachment, record: { user_id: user.id }

    can :destroy, Link, linkable: { user_id: user.id }

    can :best, Answer, question: { user_id: user.id }

    can [:like, :dislike, :reset], [Question, Answer] do |res|
      res.user_id != user.id
    end
  end
end
