require 'rails_helper'

feature 'User can unattach file from question', "
  In order to unattach file, for example, not need more
  file to concretize question as an authenticated user
  I'd like to able to delete file from attachment of question
" do
  given(:user) { create(:user) }
  given!(:user_another) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:file1) { Rack::Test::UploadedFile.new(Rails.root.join('spec/rails_helper.rb')) }
  given(:file2) { Rack::Test::UploadedFile.new(Rails.root.join('spec/spec_helper.rb')) }

  describe 'Authenticated user-author', js: true do
    background do
      sign_in(user)
      question.files.attach(file1)
      question.files.attach(file2)
      visit question_path(question)
    end

    scenario 'can unattach the file' do
      find_by_id("q-file-#{question.files[0].id}").click
      accept_alert

      expect(page).to_not have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  describe 'Unauthenticated user', js: true do
    background do
      sign_in(user_another)
      question.files.attach(file1)
      question.files.attach(file2)
      visit question_path(question)
    end

    scenario "don't see link to unattach the file" do
      expect(page).to_not have_content 'unattach'
    end
  end
end
