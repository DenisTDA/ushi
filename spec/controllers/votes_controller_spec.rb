require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let(:user) { create(:user) }
  let(:friend) { create(:user) }
  let(:question) { create(:question, author: user) }
  let!(:answer) { create(:answer, author: user) }
  let!(:vote) { create(:vote, :for_question, voter: friend) }

  describe 'DELETE #destroy' do
    context 'vote by voter' do
      before { login(friend) }

      it 'reset the vote' do
        expect do
          delete :destroy, params: { id: vote }, format: :js
        end.to change(Vote, :count).by(-1)
      end

      it 'render template destroy'
    end
  end
end
