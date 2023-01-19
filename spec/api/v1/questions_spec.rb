require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json", 
                      "ACCEPT" => "application/json" } } 

  describe 'GET /api/v1/questions' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions', headers:headers
        expect(response.status).to eq 401 
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/questions', params: { access_token: '1234' }, headers:headers
        expect(response.status).to eq 401 
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get '/api/v1/questions', params: { access_token: access_token.token }, headers:headers }

      it 'returns 200 status' do
        expect(response).to be_successful 
      end
 
      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'retuns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end
 
      it 'contains author(user) object' do
        expect(question_response['author']['id']).to eq question.author.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'] .first} 

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end
        it 'retuns all public fields' do
          %w[id body author_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json 
          end
        end
      end

    end
  end

  describe 'GET /api/v1/question/id' do
    let!(:question) { create(:question) }
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}", headers:headers
        expect(response.status).to eq 401 
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}", params: { access_token: '1234' }, headers:headers
        expect(response.status).to eq 401 
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question_response) { json['question'] }
      let(:file1) { Rack::Test::UploadedFile.new(Rails.root.join('spec/rails_helper.rb')) }
      let(:file2) { Rack::Test::UploadedFile.new(Rails.root.join('spec/spec_helper.rb')) }
      let!(:comments) { create_list(:comment, 3, commentable: question, user: create(:user)) }
      let!(:link1) { create(:link, name: 'Google', url: 'http://gogle.com', linkable: question) }
      let!(:link2) { create(:link, name: 'E1', linkable: question) }

      before do
        question.files.attach(file1)
        question.files.attach(file2)
        get "/api/v1/questions/#{ question.id }", params: { access_token: access_token.token }, headers:headers 
      end

      it 'returns 200 status' do
        expect(response).to be_successful 
      end
 
      it 'retuns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'returns list of links' do
        expect(question_response['links'].size).to eq 2
      end

      it 'returns list of comments' do
        expect(question_response['comments'].size).to eq 3
      end

      it 'returns list of attachments (files)' do
        expect(question_response['files'].size).to eq 2
      end

      it 'contains link object' do
        expect(question_response['links'].first['id']).to eq question.links.first.id
      end

      it 'contains comment object' do
        expect(question_response['comments'].first['id']).to eq question.comments.first.id
      end

      it 'contains file object' do
        expect(question_response['files'].first['id']).to eq question.files.first.id
      end

      it 'contains file url_path' do
        expect(question_response['files'].first['url_path'])
          .to eq Rails.application.routes.url_helpers.rails_blob_path(question.files.first, only_path: true)
      end

    end
  end
end
