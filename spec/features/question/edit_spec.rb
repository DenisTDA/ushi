require 'rails_helper'

feature 'User can edit question', "
  In order to edit question
  As an authenticated user
  I'd like to able to edit my question
" do
  given(:user) { create(:user) }

  scenario 'Unauthenticated user asks a question', js: true do
    visit questions_path

    expect(page).not_to have_content 'Edit'
  end

  describe 'Authenticated user - author', js: true do
    given!(:question) { create(:question, author: user) }
    given!(:file1) { Rack::Test::UploadedFile.new(Rails.root.join('spec/rails_helper.rb')) }

    background do
      sign_in(user)
      question.files.attach(file1)

      visit questions_path
      click_on 'Edit'
    end

    scenario 'edit the question' do
      fill_in 'Title', with: 'Edited title question'
      fill_in 'Body question', with: 'Test body question'
      click_on 'Save'

      expect(page).to_not have_content question.body
      expect(page).to have_content 'Edited title question'
      expect(page).to_not have_selector 'textarea'
    end

    scenario 'try to save updated question with errors' do
      fill_in 'Title', with: ''
      fill_in 'Body question', with: ''
      click_on 'Save'

      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'add files' do
      attach_file 'Files', [Rails.root.join('spec/spec_helper.rb')]
      click_on 'Save'

      visit question_path(question)

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'add links' do
      click_on 'add link'

      fill_in 'Link name', with: 'Google'
      fill_in 'Url', with: 'http://google.com'

      click_on 'Save'

      visit question_path(question)
      expect(page).to have_link 'Google', href: 'http://google.com'
    end
  end

  describe "Authenticated user - is't author", js: true do
    given(:question) { create(:question, author: user) }
    given(:user_not_author) { create(:user) }

    background do
      sign_in(user_not_author)

      visit questions_path
    end

    scenario 'try edit question of another user' do
      visit questions_path

      expect(page).not_to have_content 'Edit'
    end
  end
end
