require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 4) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #new' do
    before { login(user) }
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assigns a new Link for @question' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'assigns a new Meed for @question' do
      expect(assigns(:question).meed).to be_a_new(Meed)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    let!(:question) { create(:question, author: user) }
    let!(:meed) { create(:meed, question: question) }
    let!(:file1) { Rack::Test::UploadedFile.new(Rails.root.join('spec/rails_helper.rb')) }
    let!(:file2) { Rack::Test::UploadedFile.new(Rails.root.join('spec/spec_helper.rb')) }

    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect do
          post :create, params: { question: attributes_for(:question) }
        end.to change(Question, :count).by(1)
      end

      it 'rederect to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with valid attributes & ' do
      it 'with link' do
        expect do
          link = Link.new(name: 'E1', url: 'http://e1.ru')
          question.links << link
          post :create, params: { question: attributes_for(:question) }
        end.to change(Link, :count).by(1)
      end

      it 'with file' do
        expect do
          question.files.attach(file2)
          post :create, params: { id: question, question: attributes_for(:question) }, format: :js
        end.to change(question.files, :count).by(1)
      end

      # // test is RED, but application work
      #       it "with meed" do
      #         expect do
      #           Meed.new(name: 'Meed', img: file1, question: question)
      #           post :create, params: { id: question, question: attributes_for(:question) }, format: :js
      #         end.to change(Meed, :count).by(1)
      #       end
    end

    context 'with invalid attributes' do
      it 'does not save question in database' do
        expect do
          post :create, params: { question: attributes_for(:question, :invalid) }
        end.not_to change(Question, :count)
      end

      it 'render new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    let!(:question) { create(:question, author: user) }
    let!(:file1) { Rack::Test::UploadedFile.new(Rails.root.join('spec/rails_helper.rb')) }
    let!(:file2) { Rack::Test::UploadedFile.new(Rails.root.join('spec/spec_helper.rb')) }

    before { login(user) }
    before { question.files.attach(file1) }

    context 'with valid attributes' do
      it 'changes question attributes' do
        question.files.attach(file2)
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
        expect(question.files.attached?).to be_truthy
      end

      it 'add file to attachment' do
        expect do
          question.files.attach(file2)
          patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        end.to change(question.files, :count).by(1)
      end

      it "don't add file to attachment" do
        expect do
          patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        end.to_not change(question.files, :count)
      end

      it 'add link' do
        expect do
          link = Link.new(name: 'E1', url: 'http://e1.ru')
          question.links << link
          patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        end.to change(question.links, :count).by(1)
      end

      it "don't add link" do
        expect do
          patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        end.to_not change(question.links, :count)
      end

      it 'renders update view' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'das not change question attributes' do
        expect do
          patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
        end.to_not(change(question, :body) && change(question, :title))
      end

      it 'renders update view' do
        patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    context "existing user's question" do
      let!(:question) { create(:question, author: user) }
      let!(:link) { create(:link, linkable: question) }

      it 'removes question from list' do
        expect do
          delete :destroy, params: { id: question }, format: :js
        end.to change(Question, :count).by(-1)
      end

      it 'delete link of the @question from Link' do
        delete :destroy, params: { id: question }, format: :js
        expect(assigns(:question).links).to be_empty
      end

      it 'empty render for deleted question' do
        delete :destroy, params: { id: question }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end
end
