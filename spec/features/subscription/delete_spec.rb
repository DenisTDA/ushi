feature 'User can delete subscription', "
  In order to not get answers more
  As an authenticated user
  I'd like to able to unsibscribe to question's topic
" do
  given(:user) { create(:user) }
  given(:friend) { create(:user) }
  given!(:question) { create(:question, author: friend) }
  given!(:answer) { create(:answer, author: friend, question: question) }
  given!(:subscription) { create(:subscription, user: friend, question: question) }

  describe 'Unauthenticated user', js: true do
    scenario 'try to unsubscribe' do
      visit question_path(question)

      expect(page).to_not have_link 'Subscribe'
      expect(page).to_not have_link 'Unsubscribe'
    end
  end

  describe 'Authenticated user', js: true do
    scenario 'try to unsubscribe' do
      sign_in(friend)
      visit question_path(question)
      click_on 'Unsubscribe'

      expect(page).to have_link 'Subscribe'
    end
  end
end
