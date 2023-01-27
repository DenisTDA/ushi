require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

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

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq questions.count
      end

      it 'retuns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'does not return undeclared fields' do
        expect(question_response).to_not have_key('author_id')
      end

      it 'contains author(user) object' do
        expect(question_response['author']['id']).to eq question.author.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { question.answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'retuns all public fields' do
          %w[id body selected created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end

        it 'does not return undeclared fields of answer' do
          %w[user_id].each do |attr|
            expect(answer_response).to_not have_key(attr)
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
      let!(:links) { create_list(:link, 3, linkable: question) }

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

      it 'does not return undeclared fields' do
        expect(question_response).to_not have_key('author_id')
      end

      it_behaves_like 'Object containable' do
        let(:object) { question }
        let(:responce_object) { question_response }
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:question) { create(:question) }
    let(:question_attr) { attributes_for(:question) }
    let(:question_attr_invalid) { attributes_for(:question, :invalid) }
    let(:api_path) { '/api/v1/questions' }

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
          post api_path, params: { question: question_attr,
                                   access_token: access_token.token },
                         headers: headers
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
        expect do
          post '/api/v1/questions', params: { access_token: access_token.token,
                                              question: question_attr_invalid }, headers: headers
        end
          .to_not change(Question, :count)
      end

      it 'should contain key errors' do
        expect(json).to have_key('errors')
      end
    end
  end

  describe 'PATCH /api/v1/questions' do
    let(:question) { create(:question) }
    let(:question_attr) { { title: 'new title', body: 'new body' } }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      let(:question_json) { json['question'] }
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      context 'author of question' do
        let(:question) { create(:question, author: user) }
        context 'with valid attributes' do
          before do
            patch api_path, params:
              { id: question, question: question_attr,
                access_token: access_token.token }, headers: headers
          end

          it 'returns status accepted' do
            expect(response).to be_accepted
          end

          it 'update attributes of question' do
            question.reload
            expect(question.title).to eq 'new title'
            expect(question.body).to eq 'new body'
          end

          it 'returns values which was sent in parameters' do
            %w[title body].each do |attr|
              expect(question_json[attr]).to eq question_attr[attr.to_sym]
            end
          end
        end

        context 'with invalid attributes' do
          let(:question_attr_invalid) { { title: '', body: '' } }
          let(:old_title) { question.title }
          let(:old_body) { question.body }

          before do
            patch api_path, params: { id: question, question: question_attr_invalid,
                                      access_token: access_token.token }, headers: headers
          end

          it 'returns errors with invalid attributes' do
            expect(response).to be_bad_request
          end

          it 'does not update attributes of the question' do
            question.reload

            expect(question.title).to eq old_title
            expect(question.body).to eq old_body
          end

          it 'should contain key errors' do
            expect(json).to have_key('errors')
          end
        end
      end

      context 'is not author of the question' do
        let(:friend) { create(:user) }
        let(:question) { create(:question, author: friend) }
        let(:old_title) { question.title }
        let(:old_body) { question.body }

        before do
          patch api_path, params:
            { access_token: access_token.token,
              question: question_attr }, headers: headers
        end

        it 'returns status code 403' do
          expect(response).to be_forbidden
        end

        it 'does not change attributes of the question' do
          question.reload

          expect(question.title).to eq old_title
          expect(question.body).to eq old_body
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/id' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      let!(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      context 'is author of the question' do
        before { question.update(author: user) }

        it 'returns status code 204' do
          delete api_path, params: { access_token: access_token.token }, headers: headers

          expect(response).to be_accepted
        end

        it 'deletes the question' do
          expect do
            delete api_path, params:
            { access_token: access_token.token }, headers: headers
          end
            .to change(user.problems, :count).by(-1)
        end
      end

      context 'is not author of question' do
        it 'returns status code 403' do
          delete api_path, params: { access_token: access_token.token }, headers: headers

          expect(response).to be_forbidden
        end

        it "doesn't delete the question" do
          question.reload

          expect do
            delete api_path, params:
            { access_token: access_token.token }, headers: headers
          end
            .to_not change(Question, :count)
        end
      end
    end
  end
end
