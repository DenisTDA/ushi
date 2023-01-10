require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
    it { should_not be_able_to :read, Meed }
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
    let(:file1) { Rack::Test::UploadedFile.new(Rails.root.join('spec/rails_helper.rb')) }

    before do
      question.files.attach(file1)
      question1.files.attach(file1)
      answer.files.attach(file1)
      answer1.files.attach(file1)
    end
    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }
    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, question }
    it { should_not be_able_to :update, question1 }
    it { should be_able_to :update, answer }
    it { should_not be_able_to :update, answer1 }

    it { should be_able_to :destroy, question }
    it { should_not be_able_to :destroy, question1 }
    it { should be_able_to :destroy, answer }
    it { should_not be_able_to :destroy, answer1 }

    it { should be_able_to :destroy, create(:link, linkable: question) }
    it { should_not be_able_to :destroy, create(:link, linkable: question1) }
    it { should be_able_to :destroy, create(:link, linkable: answer) }
    it { should_not be_able_to :destroy, create(:link, linkable: answer1) }

    it { should be_able_to :index, Meed }

    it { should be_able_to :comment, Question }
    it { should be_able_to :comment, Answer }

    it { should be_able_to :select, create(:answer, question: question) }
    it { should_not be_able_to :select, create(:answer, question: question1) }

    it { should be_able_to :destroy, question.files.first }
    it { should_not be_able_to :destroy, question1.files.first }
    it { should be_able_to :destroy, answer.files.first }
    it { should_not be_able_to :destroy, answer1.files.first }

    it { should be_able_to :vote, Vote.new(voteable: question1, voter: user) }
    it { should be_able_to :vote, Vote.new(voteable: answer1, voter: user) }
    it { should_not be_able_to :vote, Vote.new(voteable: question, voter: user) }
    it { should_not be_able_to :vote, Vote.new(voteable: answer, voter: user) }

    it { should be_able_to :destroy, create(:vote, voteable: question1, voter: user) }
    it { should_not be_able_to :destroy, create(:vote, voteable: question, voter: friend) }
    it { should be_able_to :destroy, create(:vote, voteable: answer1, voter: user) }
    it { should_not be_able_to :destroy, create(:vote, voteable: answer, voter: friend) }
  end
end
