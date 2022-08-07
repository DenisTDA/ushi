require 'rails_helper'

feature 'User can create answer', "
  In order to answer to another user
  As a user I'd like to able to write
  a answer on the question
" do
  given(:question) { create(:question) }
  given(:user) { create(:user) }

  
  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question.id)
      click_on 'Answer'
    end

    scenario 'create an answer on the question' do
      fill_in 'Body', with: 'Answer text text text'
      click_on 'Answer'

      expect(page).to have_content 'Answer successfully created'
      expect(page).to have_content 'Answer text text text'
    end

    scenario 'create an answer with errors' do
      expect(page).to have_content "Answer's body can't be be blank"
    end
  end
end
