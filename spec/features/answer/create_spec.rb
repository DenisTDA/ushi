require 'rails_helper'

feature 'User can create answer', "
  In order to answer to another user
  As a user I'd like to able to write
  a answer on the question
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'create an answer on the question' do
      fill_in 'Your answer', with: 'Answer text text text'
      click_on 'Answer'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'Answer text text text'
      end
    end

    scenario 'create an answer with errors' do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'create an answer on the question with attached file' do
      fill_in 'Your answer', with: 'Answer text with attachement'
      attach_file  'Files', ["#{ Rails.root}/spec/rails_helper.rb", "#{ Rails.root}/spec/spec_helper.rb"]
      click_on 'Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user left an answer' do
    visit question_path(question)
    fill_in 'Your answer', with: 'Answer text'
    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end
