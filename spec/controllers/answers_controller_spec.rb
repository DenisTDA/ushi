require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  it_behaves_like 'commented'

  let(:question) { create(:question) }
  let(:answers) { create_list(:answer, 10, question: question) }
  let!(:user) { create(:user) }

  describe 'GET #index' do
    before { get :index, params: { question_id: question } }

    it 'poputates an array of answers of the question' do
      answers_array = question.answers
      expect(assigns(:answers)).to match_array(answers_array)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #new' do
    before { login(user) }
    before { get :new, params: { question_id: question } }

    it 'assigns a new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns a new Link for @answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      let(:answer_attr) { attributes_for(:answer) }

      it 'saves a new answer' do
        expect do
          post :create, params: { question_id: question, answer: answer_attr }, format: :js
        end.to change(Answer, :count).by(1)
      end

      it 'renders create template' do
        post :create, params: { question_id: question, answer: answer_attr }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      let(:answer_attr) { attributes_for(:answer, :invalid) }

      it 'does not save answer' do
        expect do
          post :create, params: { question_id: question, answer: answer_attr }, format: :js
        end.not_to change(Answer, :count)
      end

      it 'renders create template' do
        post :create, params: { question_id: question, answer: answer_attr }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question, author: user) }
    let!(:file1) { Rack::Test::UploadedFile.new(Rails.root.join('spec/rails_helper.rb')) }
    let!(:file2) { Rack::Test::UploadedFile.new(Rails.root.join('spec/spec_helper.rb')) }

    before { login(user) }
    before { answer.files.attach(file1) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        answer.files.attach(file2)
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
        expect(answer.files.attached?).to be_truthy
      end

      it 'add file to attachment' do
        expect do
          answer.files.attach(file2)
          patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
        end.to change(answer.files, :count).by(1)
      end

      it "don't add file to attachment" do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
        end.to_not change(answer.files, :count)
      end

      it 'add link' do
        expect do
          link = Link.new(name: 'E1', url: 'http://e1.ru')
          answer.links << link
          patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
        end.to change(answer.links, :count).by(1)
      end

      it "don't add link" do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
        end.to_not change(answer.links, :count)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'das not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe 'PATCH #select' do
    let!(:question) { create(:question, author: user) }
    let!(:answer) { create(:answer, question: question) }
    let!(:answer_best) { create(:answer, selected: true, question: question) }
    let!(:guest) { create(:user) }

    context 'change the best answer' do
      before { login(user) }
      before { patch :select, params: { id: answer } }

      it "selected answer change attribute 'selected' - true" do
        expect(answer.reload.selected).to be true
      end

      it "best answer change attribute 'selected' - false" do
        expect(answer_best.reload.selected).to be false
      end

      it "renders question's view" do
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'guest tries to change the best answer' do
      before { login(guest) }

      it "selected answer don't change attribute 'selected' - false" do
        expect(answer.reload.selected).to be false
      end

      it "the best answer don't change attribute 'selected' - true" do
        expect(answer_best.reload.selected).to be true
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, author: user) }
    before { login(user) }

    context 'author tries delete existing answer' do
      it 'removes answer from list' do
        expect do
          delete :destroy, params: { id: answer }, format: :js
        end.to change(Answer, :count).by(-1)
      end

      it 'render for deleted answer' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'another usere tries to delete answer' do
      let!(:guest) { create(:user) }
      before { login(guest) }

      it 'removes answer from list' do
        expect do
          delete :destroy, params: { id: answer }, format: :js
        end.to_not change(Answer, :count)
      end
    end
  end
end
