require 'rails_helper'

feature 'User can delete answer', "
  In order to remove, for example, incorrect
  answer as an authenticated user
  I'd like to able to delete my answer
" do
  given(:user) { create(:user) }
  given(:user_another) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user-author', js: true do
    background do
      sign_in(user)
    end

    scenario 'deletes own answer' do
      create(:answer, body: 'Body for delete', question: question, author: user)
      visit question_path(question)
      click_on 'Delete'
      accept_confirm

      expect(page).to have_content 'Answer successfully deleted'
      expect(page).to_not have_content 'Body for delete'
    end

    scenario "deletes someone's answer" do
      create(:answer, author: user_another)
      visit question_path(question)

      expect(page).to_not have_content 'Delete'
    end
  end

  scenario 'Unauthenticated user trying delete a answer', js: true do
    create(:answer, author: user_another)
    visit question_path(question)

    expect(page).to_not have_content 'Delete'
  end
end
