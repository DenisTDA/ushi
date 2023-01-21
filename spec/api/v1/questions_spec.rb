require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "ACCEPT" => "application/json" } } 

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers }

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
        let(:answer_response) { question_response['answers'].first} 

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
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
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
        get api_path, params: { access_token: access_token.token }, headers: headers 
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

  describe 'POST /api/v1/questions' do
    let(:question) { create(:question) }
    let(:question_attr) { attributes_for(:question) }
    let(:question_attr_invalid) { attributes_for(:question, :invalid) }
    let(:api_path) { "/api/v1/questions" }
   
    it_behaves_like 'API authorizable' do
      let(:method) { :post }
    end

    context 'authorized & with valid attributes' do
      let(:access_token) { create(:access_token) }
      let(:question_json) { json['question'] }

      before do
        post api_path, params: { question: question_attr, access_token: access_token.token }, headers: headers 
      end

      it 'returns status created' do
        expect(response).to be_created
      end

      it 'saves a new question in the database' do
        expect do
          post api_path, params: { question: question_attr, access_token: access_token.token }, headers: headers 
        end.to change(Question, :count).by(1)
      end

      it 'returns values which was sent in parameters' do
        %w[title body].each do |attr|
          expect(question_json[attr]).to eq question_attr[attr.to_sym]
        end
      end
    end

    context 'authorized & with invalid attributes' do
      let(:access_token) { create(:access_token) }
      let(:question_json) { json['question'] }

      before do
        post api_path, params: { question: question_attr_invalid, 
                                            access_token: access_token.token }, headers: headers 
      end

      it 'returns errors with invalid attributes' do
        expect(response).to be_bad_request 
      end

      it 'does not save the question' do
        expect { post "/api/v1/questions", params: { access_token: access_token.token, 
                    question: question_attr_invalid }, headers: headers }.
          to_not change(Question, :count)
      end

      it 'should contain key errors' do
        post api_path, params: { access_token: access_token.token, 
                                            question: question_attr_invalid }, headers: headers

        expect(json).to have_key('errors')
      end
    end
  end

  describe 'PATCH /api/v1/questions' do
    let(:question) { create(:question) }
    let(:question_attr) { {title: 'new title', body: 'new body'} }
    let(:question_attr_invalid) { {title: 'new title', body: ''} }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    

    it_behaves_like 'API authorizable' do
      let(:method) { :patch }
    end

    context 'authorized & with valid attributes' do
      let(:access_token) { create(:access_token) }
      let(:question_json) { json['question'] }

      before do
        patch api_path, params: { id: question, question: question_attr, 
          access_token: access_token.token }, headers: headers 
      end

      it 'returns status created' do
        expect(response).to be_successful
      end

      it 'update a new data of question in the database' do
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'returns values which was sent in parameters' do
        question.reload
        %w[title body].each do |attr|
          expect(question_json[attr]).to eq question_attr[attr.to_sym]
        end
      end
    end

    context 'authorized & with invalid attributes' do
      let(:access_token) { create(:access_token) }
      let(:question_json) { json['question'] }
      let(:old_title) { question.title }
      let(:old_body) { question.body }

      before do
        patch api_path, params: { id: question, question: question_attr_invalid, 
                                  access_token: access_token.token }, headers: headers 
      end

      it 'returns errors with invalid attributes' do
        expect(response).to be_bad_request 
      end

      it 'does not update the question' do
        question.reload
        expect(question.title).to eq old_title
        expect(question.body).to eq old_body
     end

      it 'should contain key errors' do
        patch api_path, params: { access_token: access_token.token, 
                                            question: question_attr_invalid }, headers: headers
        expect(json).to have_key('errors')
      end
    end
  end


end
