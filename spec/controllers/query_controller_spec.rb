require 'rails_helper'

RSpec.describe QueryController, type: :controller do
  describe 'GET #search' do
    let!(:params_incorrect) { { subjects: ['question'], search: '', page: '0', per_page: 15 } }

    context 'with correct params for Question' do
      let!(:question) { create(:question, title: 'Title title') }
      let!(:params) { { subjects: ['question'], search: 'Title title', page: '0', per_page: 15 } }

      it 'status 2xx' do
        expect(ThinkingSphinx).to receive(:search).with('Title title', page: '0', classes: [Question],
                                                                       per_page: 15).and_return([question])
        get :search, params: params, xhr: true, format: :js
        expect(response).to be_successful
      end

      it 'renders template search' do
        allow(ThinkingSphinx).to receive(:search).with('Title title', page: '0', classes: [Question],
                                                                      per_page: 15).and_return([question])
        get :search, params: params, xhr: true, format: :js
        expect(response).to render_template :search
      end
    end

    context 'with correct params for Answer' do
      let!(:answer) { create(:answer, body: 'Answer body') }
      let!(:params) { { subjects: ['answer'], search: 'Answer body', page: '0', per_page: 15 } }

      it 'status 2xx' do
        expect(ThinkingSphinx).to receive(:search).with('Answer body', page: '0', classes: [Answer],
                                                                       per_page: 15).and_return([answer])
        get :search, params: params, xhr: true, format: :js
        expect(response).to be_successful
      end

      it 'renders template search' do
        allow(ThinkingSphinx).to receive(:search).with('Answer body', page: '0', classes: [Answer],
                                                                      per_page: 15).and_return([answer])
        get :search, params: params, xhr: true, format: :js
        expect(response).to render_template :search
      end
    end

    context 'with correct params for Comment' do
      let!(:comment) { create(:answer, body: 'Comment body') }
      let!(:params) { { subjects: ['comment'], search: 'Comment body', page: '0', per_page: 15 } }

      it 'status 2xx' do
        expect(ThinkingSphinx).to receive(:search).with('Comment body', page: '0', classes: [Comment],
                                                                        per_page: 15).and_return([comment])
        get :search, params: params, xhr: true, format: :js
        expect(response).to be_successful
      end

      it 'renders template search' do
        allow(ThinkingSphinx).to receive(:search).with('Comment body', page: '0', classes: [Comment],
                                                                       per_page: 15).and_return([comment])
        get :search, params: params, xhr: true, format: :js
        expect(response).to render_template :search
      end
    end

    context 'with correct params for User' do
      let!(:user) { create(:user) }
      let!(:params) { { subjects: ['user'], search: user.email, page: '0', per_page: 15 } }

      it 'status 2xx' do
        expect(ThinkingSphinx).to receive(:search).with(user.email, page: '0', classes: [User],
                                                                    per_page: 15).and_return([user])
        get :search, params: params, xhr: true, format: :js
        expect(response).to be_successful
      end

      it 'renders template search' do
        allow(ThinkingSphinx).to receive(:search).with(user.email, page: '0', classes: [User],
                                                                   per_page: 15).and_return([user])
        get :search, params: params, xhr: true, format: :js
        expect(response).to render_template :search
      end
    end

    context 'with correct params for all classes' do
      let!(:question) { create(:question, title: 'Title title ruby') }
      let!(:answer) { create(:answer, body: 'Answer body ruby') }
      let!(:comment) { create(:answer, body: 'Comment body ruby') }
      let!(:user) { create(:user, email: 'ruby@mail.com') }
      let!(:params) { { subjects: %w[question answer comment user], search: 'ruby', page: '0', per_page: 15 } }

      it 'status 2xx' do
        expect(ThinkingSphinx).to receive(:search).with('ruby', page: '0', classes: [Question, Answer, Comment, User],
                                                                per_page: 15).and_return([user, answer, question,
                                                                                          comment])
        get :search, params: params, xhr: true, format: :js
        expect(response).to be_successful
      end

      it 'renders template search' do
        allow(ThinkingSphinx).to receive(:search).with('ruby', page: '0', classes: [Question, Answer, Comment, User],
                                                               per_page: 15).and_return([user, answer, question,
                                                                                         comment])
        get :search, params: params, xhr: true, format: :js
        expect(response).to render_template :search
      end
    end

    context 'with incorrect params' do
      let!(:response_search) { 'Nothing found' }
      it 'status 2xx with no found' do
        expect(ThinkingSphinx).to_not receive(:search)
        get :search, params: params_incorrect, xhr: true, format: :js
        expect(response).to be_successful
      end

      it 'renders template search' do
        expect(ThinkingSphinx).to_not receive(:search)
        get :search, params: params_incorrect, xhr: true, format: :js
        expect(response).to render_template :search
      end
    end
  end

  describe 'GET #new' do
    it 'status 2xx' do
      get :new
      expect(response).to be_successful
    end

    it 'render template new' do
      get :new
      expect(response).to render_template :new
    end
  end
end
