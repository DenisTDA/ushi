require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
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
    let!(:answer) { create(:answer, question: question) }

    before { login(user) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
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
    before { login(user) }

    context "existing user's answer" do
      let!(:answer) { create(:answer, author_id: user.id) }
      it 'removes answer from list' do
        expect do
          post :destroy, params: { id: answer }, format: :js
        end.to change(Answer, :count).by(-1)
      end

      it 'empty render for deleted answer' do
        patch :destroy, params: { id: answer }, format: :js
        expect(response).to render_template nil
      end
    end
  end
end
