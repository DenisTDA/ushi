require 'rails_helper'

feature 'User can edit answer', "
  In order to edit his answer user
  As a user I'd like to able to edit
  my answer on the question
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, author: user) }

  scenario 'Anauthenticated user tries edit any answer', js: true do
    visit question_path(question)
 
    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
  
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
    
    scenario 'edit his answer with errors' do
      within '.answers' do
        fill_in 'Your answer', with: ''
        click_on 'Save'
      end

        expect(page).to have_content "Body can't be blank"
    end
  end
end
