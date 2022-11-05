require 'rails_helper'

RSpec.describe MeedsController, type: :controller do
  let(:user) { create(:user) }
  let(:friend) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer, author: user) }
  let!(:meeds) { create_list(:meed, 3, question: question, answer: answer) }

  describe 'GET #index' do
    it 'populates an array of all users rewards' do
      login(user)
      get :index

      expect(assigns(:meeds)).to match_array(meeds)
    end

    it "populates empty array if user doesn't have meeds" do
      login(friend)
      get :index

      expect(assigns(:meeds)).to be_empty
    end

    it 'renders index view' do
      login(user)
      get :index

      expect(response).to render_template :index
    end
  end
end
