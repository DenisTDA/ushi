require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:friend) { create(:user) }
  let(:question) { create(:question, author: user) }
  let!(:answer) { create(:answer, author: user) }
  let!(:link1) { create(:link, name: 'Google', linkable: question) }
  let!(:link2) { create(:link, name: 'E1', linkable: question) }
  
  describe 'DELETE #destroy' do
    context 'link of a question by author' do
      before { login(user) }

      it 'removes link' do
        expect do
          delete :destroy, params: { id: link1 }, format: :js
        end.to change(question.links, :count).by(-1)
      end

      it 'render template destroy' do
        delete :destroy, params: { id: link1 }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end
end
