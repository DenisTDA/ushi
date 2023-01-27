require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }
  let!(:question) { create(:question) }
  let!(:answers) { create_list(:answer, 4, question: question) }

  describe 'GET /api/v1/questions/question_id/answers' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer_json) { json['answers'].first }
      let(:answer) { answers.first }

      before do
        get "/api/v1/questions/#{question.id}/answers", params: { access_token: access_token.token }, headers: headers
      end

      it 'return 200 status' do
        expect(response).to be_successful
      end

      it 'return list of answers' do
        expect(json['answers'].size).to eq question.answers.size
      end

      it 'return all public attributes' do
        %w[id body created_at updated_at].each do |attr|
          expect(answer_json[attr]).to eq answer.send(attr).as_json
        end
      end

      it 'does not return undeclared fields' do
        %w[author_id selected].each do |attr|
          expect(answer_json).to_not have_key(attr)
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

  describe 'GET /api/v1/answers/id' do
    let(:answer) { create(:answer, question: question) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer_json) { json['answer'] }
      let(:file1) { Rack::Test::UploadedFile.new(Rails.root.join('spec/rails_helper.rb')) }
      let(:file2) { Rack::Test::UploadedFile.new(Rails.root.join('spec/spec_helper.rb')) }
      let!(:comments) { create_list(:comment, 3, commentable: answer, user: create(:user)) }
      let!(:links) { create_list(:link, 3, linkable: answer) }

      before do
        answer.files.attach(file1)
        answer.files.attach(file2)
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public attributes' do
        %w[id body selected created_at updated_at].each do |attr|
          expect(answer_json[attr]).to eq answer.send(attr).as_json
        end
      end

      it 'does not return undeclared fields' do
        %w[author_id question_id].each do |attr|
          expect(answer_json).to_not have_key(attr)
        end
      end

      it_behaves_like 'Object containable' do
        let(:object) { answer }
        let(:responce_object) { answer_json }
      end
    end
  end

  describe 'POST /api/v1/questions/question_id/answers' do
    let(:question) { create(:question) }
    let(:answer_attr) { attributes_for(:answer) }
    let(:answer_attr_invalid) { attributes_for(:answer, :invalid) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API authorizable' do
      let(:method) { :post }
    end

    context 'authorized & with valid attributes' do
      let(:access_token) { create(:access_token) }
      let(:answer_json) { json['answer'] }

      before do
        post api_path, params: { answer: answer_attr,
                                 question: question,
                                 access_token: access_token.token },
                       headers: headers
      end

      it 'returns status created' do
        expect(response).to be_created
      end

      it 'saves a new answer in the database' do
        expect do
          post api_path, params: { answer: answer_attr,
                                   question: question,
                                   access_token: access_token.token },
                         headers: headers
        end.to change(question.answers, :count).by(1)
      end

      it 'returns values which was sent in parameters' do
        %w[body].each do |attr|
          expect(answer_json[attr]).to eq answer_attr[attr.to_sym]
        end
      end
    end

    context 'authorized & with invalid attributes' do
      let(:access_token) { create(:access_token) }
      let(:answer_json) { json['answer'] }

      before do
        post api_path, params: { answer: answer_attr_invalid,
                                 question: question,
                                 access_token: access_token.token },
                       headers: headers
      end

      it 'returns errors with invalid attributes' do
        expect(response).to be_bad_request
      end

      it 'does not save the question' do
        expect do
          post api_path, params: { access_token: access_token.token,
                                   answer: answer_attr_invalid, question: question }, headers: headers
        end
          .to_not change(question.answers, :count)
      end

      it 'should contain key errors' do
        expect(json).to have_key('errors')
      end
    end
  end

  describe 'PATCH /api/v1/answers/id' do
    let(:answer_attr) { { body: 'new body' } }
    let(:answer) { create(:answer) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      let(:answer_json) { json['answer'] }
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      context 'author of answer' do
        let(:answer) { create(:answer, author: user, question: question) }
        context 'with valid attributes' do
          before do
            patch api_path, params:
              { id: answer, answer: answer_attr,
                access_token: access_token.token }, headers: headers
          end

          it 'returns status successful' do
            expect(response).to be_successful
          end

          it 'update attributes' do
            answer.reload
            expect(answer.body).to eq 'new body'
          end

          it 'returns values which was sent in parameters' do
            expect(answer_json['body']).to eq answer_attr[:body]
          end
        end

        context 'with invalid attributes' do
          let(:answer_attr_invalid) { { body: '' } }
          let(:old_body) { answer.body }

          before do
            patch api_path, params:
              { id: answer, answer: answer_attr_invalid,
                access_token: access_token.token }, headers: headers
          end

          it 'returns bad_request' do
            expect(response).to be_bad_request
          end

          it 'does not update attributes' do
            answer.reload

            expect(answer.body).to eq old_body
          end

          it 'should contain key errors' do
            expect(json).to have_key('errors')
          end
        end
      end

      context 'is not author' do
        let(:friend) { create(:user) }
        let(:answer) { create(:answer, author: friend) }
        let(:old_body) { answer.body }

        before do
          patch api_path, params:
            { access_token: access_token.token,
              answer: answer_attr }, headers: headers
        end

        it 'returns status code 403' do
          expect(response).to be_forbidden
        end

        it 'does not change attributes' do
          answer.reload

          expect(answer.body).to eq old_body
        end
      end
    end
  end

  describe 'DELETE /api/v1/answers/id' do
    let(:user) { create(:user) }
    let!(:answer) { create(:answer, author: user) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      context 'is author' do
        it 'returns status code 204' do
          delete api_path, params: { access_token: access_token.token }, headers: headers

          expect(response).to be_accepted
        end

        it 'deletes from a database' do
          expect do
            delete api_path, params:
            { access_token: access_token.token }, headers: headers
          end
            .to change(user.replies, :count).by(-1)
        end
      end

      context 'is not author' do
        let(:answer) { create(:answer) }

        it 'returns status code 403' do
          delete api_path, params: { access_token: access_token.token }, headers: headers

          expect(response).to be_forbidden
        end

        it "doesn't delete from a database" do
          answer.reload

          expect do
            delete api_path, params:
            { access_token: access_token.token }, headers: headers
          end
            .to_not change(Answer, :count)
        end
      end
    end
  end
end
