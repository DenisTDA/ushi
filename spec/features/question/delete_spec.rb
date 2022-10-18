require 'rails_helper'

feature 'User can delete question', "
  In order to remove, for example, incorrect
  question as an authenticated user
  I'd like to able to delete my question
" do
  given!(:user) { create(:user) }
  given!(:user_another) { create(:user) }

  describe 'Authenticated user-author', js: true do
    background do
      sign_in(user)
    end

    scenario 'deletes own question' do
      create(:question, title: 'Title for delete', author: user)
      visit questions_path
      click_on 'Delete'
      accept_confirm

      expect(page).to have_content 'Question successfully deleted'
      expect(page).to_not have_content 'Title for delete'
    end

    scenario 'deletes someone question' do
      create(:question, author: user_another)
      visit questions_path

      expect(page).to_not have_content 'Delete'
    end
  end

  scenario 'Unauthenticated user trying delete a question', js: true do
    create(:question, author: user_another)
    visit questions_path

    expect(page).to_not have_content 'Delete'
  end
end
