require 'rails_helper'

feature 'User can create subscription', "
  In order to get answers for intresting question
  As an authenticated user
  I'd like to able to sibscribe to question's topic
" do
  given(:user) { create(:user) }
  given(:friend) { create(:user) }
  given!(:question) { create(:question, author: friend) }
  given!(:answer) { create(:answer, author: friend, question: question) }
  given!(:subscription) { create(:subscription, user: friend, question: question) }

  describe 'Unauthenticated user', js: true do
    scenario 'try to subscribe' do
      visit question_path(question)

      expect(page).to_not have_link 'Subscribe'
      expect(page).to_not have_link 'Unsubscribe'
    end
  end

  describe 'Authenticated user', js: true do
    scenario 'try to subscribe' do
      sign_in(user)
      visit question_path(question)
      click_on 'Subscribe'

      expect(page).to have_link 'Unsubscribe'
    end
  end
end
