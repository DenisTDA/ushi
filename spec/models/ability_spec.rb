require 'rails_helper'

describe Ability do 
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
    
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:friend) { create :user }
    let(:answer) { create(:answer, author: user) }
    let(:answer1) { create(:answer, author: friend) }
    let(:question1) { create(:question, author: friend) }
    let(:question) { create(:question, author: user) }
    let(:comment) { create :comment, commentable: question1, user: user }
    let(:comment1) { create :comment, commentable: question, user: friend }
    let(:comment2) { create :comment, commentable: answer1, user: user }
    let(:comment3) { create :comment, commentable: answer, user: friend }


    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }
    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, question, user: user }
    it { should_not be_able_to :update, question1, user: user }

    it { should be_able_to :update, answer, user: user }
    it { should_not be_able_to :update, answer1, user: user }

    it { should be_able_to :update, comment, user: user }
    it { should_not be_able_to :update, comment1, user: user }

    it { should be_able_to :update, comment2, user: user }
    it { should_not be_able_to :update, comment3, user: user }
  end
end
