require 'rails_helper'

feature 'User can edit answer', "
  In order to edit his answer user
  As a user I'd like to able to edit
  my answer on the question
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, author: user) }
  given!(:file1) { Rack::Test::UploadedFile.new(Rails.root.join('spec/rails_helper.rb')) }

  scenario 'Anauthenticated user tries edit any answer', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user is author', js: true do
    background do
      sign_in(user)
      answer.files.attach(file1)

      visit question_path(question)
      click_on 'Edit'
    end

    scenario 'edit his answer on the question', js: true do
      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'add files', js: true do
      within '.answers' do
        attach_file 'Files', [Rails.root.join('spec/spec_helper.rb')]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'add links' do
      within '.answers' do
        click_on 'add link'

        fill_in 'Link name', with: 'Google'
        fill_in 'Url', with: 'http://google.com'

        click_on 'Save'

        visit question_path(question)
        expect(page).to have_link 'Google', href: 'http://google.com'
      end
    end

    scenario 'edit his answer with errors' do
      within '.answers' do
        fill_in 'Your answer', with: ''
        click_on 'Save'
      end

      expect(page).to have_content "Body can't be blank"
    end
  end
end
