require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'Github' do
    let!(:oauth_data) { mock_auth_hash('github', email: 'user@test.com') } # { 'provider' => 'github', 'uid' => 123 } }

    it 'finds user fro auth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :github
    end

    context 'user1 exist' do
      let!(:user) { create(:user) }

      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :github
      end

      it 'login user' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exist' do
      before do
        allow(User).to receive(:find_for_oauth)
        get :github
      end

      it 'does not login user' do
        expect(subject.current_user).to_not be
      end

      it 'redirect to root path' do
        expect(response).to redirect_to root_path
      end
    end
  end
end
