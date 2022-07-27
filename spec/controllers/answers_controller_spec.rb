require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'GET #list' do
    let(:question) { create(:question) }
    let(:answers) { create_list(:answer, 10, question: question)  }

    before { get :list, params: { question_id: question.id } }
    it 'poputates an array of answers of the question' do
      answers_array = question.answers
      expect(assigns(:answers)).to match_array(answers_array)
    end

    it 'renders list view' do
      expect(response).to render_template :list
    end
  end
end
