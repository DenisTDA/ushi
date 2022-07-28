require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answers) { create_list(:answer, 10, question: question) }

  describe 'GET #list' do
    before { get :list, params: { question_id: question } }

    it 'poputates an array of answers of the question' do
      answers_array = question.answers
      expect(assigns(:answers)).to match_array(answers_array)
    end

    it 'renders list view' do
      expect(response).to render_template :list
    end
  end

  describe 'GET #new' do
    before { get :new, params: { question_id: question } }

    it 'assigns a new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:answer_attr) { attributes_for(:answer) }

      it 'saves a new answer' do
        expect do
          post :create, params: { question_id: question, answer: answer_attr }
        end.to change(Answer, :count).by(1)
      end

      it 'redirect to show' do
        post :create, params: { question_id: question, answer: answer_attr }
        expect(response).to redirect_to assigns(:answer)
      end
    end

    context 'with invalid attributes' do
      let(:answer_attr) { attributes_for(:answer, :invalid) }

      it 'does not save answer' do
        expect do
          post :create, params: { question_id: question, answer: answer_attr }
        end.not_to change(Answer, :count)
      end

      it 'render new view' do
        post :create, params: { question_id: question, answer: answer_attr }
        expect(response).to render_template :new
      end
    end
  end
end
