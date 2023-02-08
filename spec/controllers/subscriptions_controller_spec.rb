require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'POST #create' do
    before { login(user) }

    it 'saves new subscription' do
      expect do
        post :create, params: { question_id: question.id }, format: :js
      end.to change(Subscription, :count).by(1)
    end

    it 'renders create template' do
      post :create, params: { question_id: question.id, user_id: user.id }, format: :js
      expect(response).to render_template :create
    end
  end

  describe 'DELETE #destroy' do
    let!(:subscription) { create(:subscription, question: question, user: user) }

    context 'by authorized user' do
      before { login(user) }

      it 'deletes subscribe fro m the database' do
        expect do
          delete :destroy, params: { id: subscription.id }, format: :js
        end.to change(user.subscriptions, :count).by(-1)
      end

      it 'renders delete template' do
        delete :destroy, params: { id: subscription.id }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'by unauthorized user' do
      it 'doesnt not delete subscribe from the database' do
        expect { delete :destroy, params: { id: subscription.id }, format: :js }.to_not change(Subscription, :count)
      end
    end
  end
end
