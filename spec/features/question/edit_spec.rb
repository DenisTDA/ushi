require 'rails_helper'

feature 'User can edit question', "
  In order to edit question
  As an authenticated user
  I'd like to able to edit my question
" do
  given(:user) { create(:user) }

  scenario 'Unauthenticated user asks a question' do
    visit questions_path    

    expect(page).not_to have_content 'Edit'
  end
  
  describe 'Authenticated user - author', js: true do
    given!(:question) { create(:question, author_id: user.id) }

    background do
      sign_in(user)

      visit questions_path
      click_on 'Edit'
    end

    scenario 'edit a question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      click_on 'Save'

      expect(page).to have_content 'Question successfully updated'
      expect(page).to have_content 'Test question'
    end

    scenario 'try to save updated question with errors' 
  end
end
