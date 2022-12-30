require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #new_email' do
    before { get :new_email }

    it 'assigns a new form of email to @user' do
      expect(assigns(:user)).to be_a_new(User)
    end

    it 'renders new email view' do
      expect(response).to render_template :new_email
    end
  end

  describe 'POST #confirm_email' do
    let!(:user_attr) { attributes_for(:user) }

    it 'confirm email for user and create user' do
      expect do
        post :confirm_email,  params: { user: user_attr },
                              session: { provider: 'GitHub', uid: '12345' }
      end.to change(User, :count).by(1)
    end

    it 'confirm email for user and create authorization' do
      expect do
        post :confirm_email,  params: { user: user_attr },
                              session: { provider: 'GitHub', uid: '12345' }
      end.to change(Authorization, :count).by(1)
    end

    it 'renders root view' do
      post :confirm_email,  params: { user: user_attr },
                            session: { provider: 'GitHub', uid: '12345' }

      expect(response).to redirect_to root_path
    end
  end
end
