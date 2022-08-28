require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answers) { create_list(:answer, 10, question: question) }
  let(:user) { create(:user) }

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

      it "renders create template" do
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

      it "renders create template" do
        post :create, params: { question_id: question, answer: answer_attr }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    let!(:answer) { create(:answer, question: question) } 

    context 'with valid attributes' do
      it "changes answer attributes" do
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
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid)  }, format: :js 
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update 
      end
    end
  end
end
