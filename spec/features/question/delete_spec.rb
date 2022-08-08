require 'rails_helper'

feature 'User can delete question', "
  In order to remove, for example, incorrect
  question as an authenticated user
  I'd like to able to delete my question
" do
  given!(:user) { create(:user) }
  given!(:user_another) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
    end

    scenario 'deletes own question' do
      create(:question, author_id: user.id)
      visit questions_path
      click_on 'Delete'

      expect(page).to have_content 'Question successfully deleted'
    end

    scenario 'deletes someone question' do
      create(:question, author_id: user_another.id)
      visit questions_path
      click_on 'Delete'

      expect(page).to have_content "Question can't be deleted"
    end
  end

  scenario 'Unauthenticated user trying delete a question' do
    create(:question, author_id: user_another.id)
    visit questions_path
    click_on 'Delete'

    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end
end
