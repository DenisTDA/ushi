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

  def guest_abilities
    can :read, :all
    cannot :read, Meed
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    can :read, :all
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer], author: user
    can :destroy, [Question, Answer], author: user
    can :destroy, Link, linkable: { author: user }
    can :comment, [Question, Answer]
    can :index, Meed
    can :destroy, ActiveStorage::Attachment do |attachment|
      user.author?(attachment.record)
    end
    can :select, Answer, question: { author: user }
    can :create, Vote do |vote|
      !user.author?(vote.voteable)
    end
    can :destroy, Vote, voter: user
    can :me, User do |profile|
      profile.id.eql?(user.id)
    end
    can :all, User
    can :me, User do |profile|
      profile.id.eql?(user.id)
    end
    can :create, Subscription
    can :destroy, Subscription, user: user
  end
end
