require 'rails_helper'

feature 'User can create vote', "
  In order to vote for intresting solutions
  As an authenticated user
  I'd like to able to vote for answer or for question
" do
  given(:user) { create(:user) }
  given(:friend) { create(:user) }
  given!(:question) { create(:question, author: friend) }
  given!(:answer) { create(:answer, author: friend, question: question) }

  describe 'Authenticated user have vote for a question and', js: true do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'reset vote for a question' do
      within '.question-block' do
        click_on "\u26D4 useless"
        click_on "\u274C reset"

        within '.vote-block' do
          expect(page).to_not have_link "\u274C reset"
          expect(page).to have_link "\u2705 useful"
          expect(page).to have_link "\u26D4 useless"
        end
      end
    end

    scenario 'reset vote for a answer' do
      within(:id, "answer-block-#{answer.id}") do
        click_on "\u26D4 useless"
        click_on "\u274C reset"

        within '.vote-block' do
          expect(page).to_not have_link "\u274C reset"
          expect(page).to have_link "\u2705 useful"
          expect(page).to have_link "\u26D4 useless"
        end
      end
    end
  end
end
