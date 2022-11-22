require 'rails_helper'

RSpec.describe Questions::VotesController, type: :controller do
  let(:user) { create(:user) }
  let!(:friend) { create(:user) }
  let!(:question) { create(:question, author: user) }
  let!(:answer) { create(:answer, author: user) }
  let!(:vote) { create(:vote, :for_question, voter: friend) }
  let!(:vote1) { create(:vote, :for_answer, voter: friend) }

  before { login(friend) }

  describe 'POST #create', format: :js do
    context 'vote by voter' do
      it 'for the question' do
        params = { useful: true }

        expect do
          post :create, params: { vote: params, question_id: question, format: :json }
        end.to change(Vote, :count).by(1)
      end
    end
  end
  describe 'DELETE #destroy', format: :js do
    context 'by voter' do
      it 'reset the vote of the question' do
        expect do
          delete :destroy, params: { id: vote, format: :json }
        end.to change(Vote, :count).by(-1)
      end
    end
  end
end

RSpec.describe Answers::VotesController, type: :controller do
  let(:user) { create(:user) }
  let!(:friend) { create(:user) }
  let!(:question) { create(:question, author: user) }
  let!(:answer) { create(:answer, author: user) }
  let!(:vote) { create(:vote, :for_question, voter: friend) }
  let!(:vote1) { create(:vote, :for_answer, voter: friend) }

  before { login(friend) }

  describe 'POST #create', format: :js do
    context 'vote by voter' do
      it 'for the answer' do
        params = { useful: true }

        expect do
          post :create, params: { vote: params, answer_id: answer, format: :json }
        end.to change(Vote, :count).by(1)
      end
    end
  end
  describe 'DELETE #destroy', format: :js do
    context 'by voter' do
      it 'reset the vote of the answer' do
        expect do
          delete :destroy, params: { id: vote1, format: :json }
        end.to change(Vote, :count).by(-1)
      end
    end
  end
end
