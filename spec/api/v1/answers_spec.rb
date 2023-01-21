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

  describe "GET /api/v1/answers/answer_id" do
    let(:answer) { create(:answer, question: question) } 
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/answers/#{answer.id}", headers:headers
        expect(response.status).to eq 401 
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/answers/#{answer.id}", params: { access_token: '1234' }, headers:headers
        expect(response.status).to eq 401 
      end
    end    

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer_json) { json['answer'] }
      let(:file1) { Rack::Test::UploadedFile.new(Rails.root.join('spec/rails_helper.rb')) }
      let(:file2) { Rack::Test::UploadedFile.new(Rails.root.join('spec/spec_helper.rb')) }
      let!(:comments) { create_list(:comment, 3, commentable: answer, user: create(:user)) }
      let!(:link1) { create(:link, name: 'Google', url: 'http://gogle.com', linkable: answer) }
      let!(:link2) { create(:link, name: 'E1', linkable: answer) }

      before do
        answer.files.attach(file1)
        answer.files.attach(file2)
        get "/api/v1/answers/#{answer.id}", params: { access_token: access_token.token }, headers:headers 
      end

      it 'returns 200 status' do
        expect(response).to be_successful 
      end

      it 'returns all public attributes' do
        %w[id body created_at updated_at].each do |attr|
          expect(answer_json[attr]).to eq answer.send(attr).as_json
        end 
      end

      it 'returns author object' do
        expect(answer_json['author']['id']).to eq answer.author.id
      end

      it 'returns question object' do
        expect(answer_json['question']['id']).to eq answer.question.id
      end

      it 'returns list of comments' do
        expect(answer_json['comments'].size).to eq answer.comments.size
      end

      it 'returns object of comment' do
        expect(answer_json['comments'].first['id']).to eq answer.comments.first.id
      end

      it 'returns list of links' do
        expect(answer_json['links'].size).to eq answer.links.size
      end

      it 'returns object of link' do
        expect(answer_json['links'].first['id']).to eq answer.links.first.id
      end

      it 'returns list of attachments' do
        expect(answer_json['files'].size).to eq answer.files.size
      end

      it 'returns object of attachment' do
        expect(answer_json['files'].first['url_path'])
          .to eq Rails.application.routes.url_helpers.rails_blob_path(answer.files.first, only_path: true)
      end
    end
  end
end
