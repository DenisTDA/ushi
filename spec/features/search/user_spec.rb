require 'sphinx_helper'

feature 'User can search for profile', "
  In order to find needed profile
  As a User
  I'd like to be able to search for the profile of user
" do
  describe "User searches for the user's profile", js: true do
    given!(:author) { create(:user, email: 'lilu@mail.com') }

    scenario 'keyword into the email', sphinx: true do
      ThinkingSphinx::Test.run do
        visit query_new_path

        fill_in 'search', with: 'lilu'
        check 'subjects_user'
        click_button 'Search'

        within '.result_search' do
          expect(page).to have_content 'lilu@mail.com'
        end
      end
    end
  end

  describe 'User searches for the profile, but ', js: true do
    describe 'check invalid resources of a search' do
      given(:author) { create(:user, email: 'lilu@mail.com') }
      given(:question) { create(:question) }
      given(:answer) { create(:answer) }
      given(:comment) { create(:comment, commentable: answer, user: create(:user)) }

      scenario 'returns emty list', sphinx: true do
        ThinkingSphinx::Test.run do
          visit query_new_path

          fill_in 'search', with: 'lilu'
          check 'subjects_question'
          check 'subjects_comment'
          check 'subjects_answer'
          click_button 'Search'

          within '.result_search' do
            expect(page).to_not have_content 'lilu@mail.com'
            expect(page).to have_content 'Nothing found'
          end
        end
      end
    end

    describe 'not have users in database with keyword' do
      given(:user) { create(:user, email: 'mem@mail.com') }
      given(:answer) { create(:answer) }
      given!(:question) { create(:question) }
      given!(:comment) do
        create(:comment, user: user,
                         commentable: answer)
      end

      scenario 'returns empty list', sphinx: true do
        ThinkingSphinx::Test.run do
          visit query_new_path

          fill_in 'search', with: 'lilu'
          check 'subjects_user'
          click_button 'Search'

          within '.result_search' do
            expect(page).to_not have_content 'test@mail.com'
            expect(page).to have_content 'Nothing found'
          end
        end
      end
    end
  end
end
