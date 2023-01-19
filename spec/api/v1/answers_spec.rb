require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json", 
                      "ACCEPT" => "application/json" } } 
  let!(:question) { create(:question) }
  let!(:answers) { create_list(:answer, 4, question: question) }

  describe 'GET /api/v1/questions/question_id/answers' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}/answers", headers:headers
        expect(response.status).to eq 401 
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}/answers", params: { access_token: '1234' }, headers:headers
        expect(response.status).to eq 401 
      end
    end    

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer_json) { json['answers'].first }
      let(:answer) { answers.first}

      before { get "/api/v1/questions/#{question.id}/answers", params: { access_token: access_token.token }, headers:headers }

      it 'return 200 status' do
        expect(response).to be_successful 
      end

      it 'return list of answers' do
        expect(json['answers'].size).to eq 4
      end

      it 'return all public attributes' do
        %w[id body created_at updated_at].each do |attr|
          expect(answer_json[attr]).to eq answer.send(attr).as_json
        end 
      end

      it 'return author object' do
        expect(answer_json['author']['id']).to eq answer.author.id
      end

      it 'return question object' do
        expect(answer_json['question']['id']).to eq answer.question.id
      end
    end
  end
end
