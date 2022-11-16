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

  describe 'Authenticated user, is not author', js: true do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'vote for a question - useful' do
      within '.question-block' do
        click_on "\u2705 useful"

        within '.vote-block' do
          expect(page).to have_link "\u274C reset"

          expect(page).to_not have_link "\u2705 useful"
          expect(page).to_not have_link "\u26D4 useless"
        end
      end
    end

    scenario 'vote for a question - useless' do
      within '.question-block' do
        click_on "\u26D4 useless"

        within '.vote-block' do
          expect(page).to have_link "\u274C reset"
          expect(page).to_not have_link "\u2705 useful"
          expect(page).to_not have_link "\u26D4 useless"
        end
      end
    end

    scenario 'vote for a answer - useful' do
      within(:id, "answer-block-#{answer.id}") do
        click_on "\u2705 useful"

        within '.vote-block' do
          expect(page).to have_link "\u274C reset"
          expect(page).to_not have_link "\u2705 useful"
          expect(page).to_not have_link "\u26D4 useless"
        end
      end
    end

    scenario 'vote for a answer - useless' do
      within(:id, "answer-block-#{answer.id}") do
        click_on "\u26D4 useless"

        within '.vote-block' do
          expect(page).to have_link "\u274C reset"
          expect(page).to_not have_link "\u2705 useful"
          expect(page).to_not have_link "\u26D4 useless"
        end
      end
    end
  end
end
