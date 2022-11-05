require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:friend) { create(:user) }
  let!(:question) { create(:question, author: user) }
  let!(:answer) { create(:answer, author: user) }
  let!(:file1) { Rack::Test::UploadedFile.new(Rails.root.join('spec/rails_helper.rb')) }
  let!(:file2) { Rack::Test::UploadedFile.new(Rails.root.join('spec/spec_helper.rb')) }

  describe 'DELETE #destroy' do
    before { question.files.attach(file1, file2) }
    before { answer.files.attach(file1, file2) }

    context 'file as the attachment to question by author' do
      before { login(user) }

      it 'removes file from list' do
        expect do
          delete :destroy, params: { id: question.files[0], holder: question }, format: :js
        end.to change(question.files, :count).by(-1)
      end

      it 'render for deleted file of the question' do
        delete :destroy, params: { id: question.files[0], holder: question }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'file as the attachment to answer by author' do
      before { login(user) }

      it 'removes file from list' do
        expect do
          delete :destroy, params: { id: answer.files[0], holder: answer }, format: :js
        end.to change(answer.files, :count).by(-1)
      end

      it 'render for deleted file of the answer' do
        delete :destroy, params: { id: answer.files[0], holder: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'file as the attachment to answer by another user' do
      before { login(friend) }

      it 'cant removes file from attachments of answer' do
        expect do
          delete :destroy, params: { id: answer.files[0], holder: answer }, format: :js
        end.to_not change(answer.files, :count)
      end

      it 'render for deleted file of the answer' do
        delete :destroy, params: { id: answer.files[0], holder: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'file as the attachment to question by another user' do
      before { login(friend) }

      it 'cant removes file from attachments of question' do
        expect do
          delete :destroy, params: { id: question.files[0], holder: question }, format: :js
        end.to_not change(question.files, :count)
      end

      it 'render for deleted file of the question' do
        delete :destroy, params: { id: question.files[0], holder: question }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end
end
