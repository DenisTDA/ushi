require 'sphinx_helper'

feature 'User can search for content', "
  In order to find needed content
  As a User
  I'd like to be able to search for content everywhere
" do
  given(:user) { create(:user) }

  describe 'User searches for the content', js: true do
    given!(:author) { create(:user, email: 'ruby@mail.com') }
    given!(:question) { create(:question, title: 'title question ruby') }
    given!(:answer) { create(:answer, body: 'body answer ruby') }
    given!(:comment2) { create(:comment, body: 'body comment ruby', commentable: question, user: user) }

    scenario 'keyword into the all resourses', sphinx: true do
      ThinkingSphinx::Test.run do
        visit query_new_path

        fill_in 'search', with: 'ruby'
        check 'all'
        click_button 'Search'

        within '.result_search' do
          expect(page).to have_content 'ruby@mail.com'
          expect(page).to have_content 'title question ruby'
          expect(page).to have_content 'body answer ruby'
          expect(page).to have_content 'body comment ruby'
        end
      end
    end
  end

  describe 'User searches for the , but ', js: true do
    describe 'check Answer & Question resources of a search' do
      given!(:author) { create(:user, email: 'ruby@mail.com') }
      given!(:question) { create(:question, title: 'title question ruby') }
      given!(:answer) { create(:answer, body: 'body answer ruby') }
      given!(:comment2) { create(:comment, body: 'body comment ruby', commentable: question, user: user) }

      scenario 'returns part of data', sphinx: true do
        ThinkingSphinx::Test.run do
          visit query_new_path

          fill_in 'search', with: 'ruby'
          check 'subjects_question'
          check 'subjects_answer'
          click_button 'Search'

          within '.result_search' do
            expect(page).to_not have_content 'body comment ruby'
            expect(page).to_not have_content 'ruby@mail.com'
            expect(page).to have_content 'title question ruby'
            expect(page).to have_content 'body answer ruby'
          end
        end
      end
    end

    describe 'check User & Comment resources of a search' do
      given!(:author) { create(:user, email: 'ruby@mail.com') }
      given!(:question) { create(:question, title: 'title question ruby') }
      given!(:answer) { create(:answer, body: 'body answer ruby') }
      given!(:comment2) { create(:comment, body: 'body comment ruby', commentable: question, user: user) }

      scenario 'returns part of data', sphinx: true do
        ThinkingSphinx::Test.run do
          visit query_new_path

          fill_in 'search', with: 'ruby'
          check 'subjects_user'
          check 'subjects_comment'
          click_button 'Search'

          within '.result_search' do
            expect(page).to have_content 'body comment ruby'
            expect(page).to have_content 'ruby@mail.com'
            expect(page).to_not have_content 'title question ruby'
            expect(page).to_not have_content 'body answer ruby'
          end
        end
      end
    end

    describe 'not have content in database with keyword' do
      given!(:answer) { create(:answer) }
      given!(:comment) { create(:comment, commentable: answer, user: user) }
      given!(:question) { create(:question) }

      scenario 'returns empty list', sphinx: true do
        ThinkingSphinx::Test.run do
          visit query_new_path

          fill_in 'search', with: 'ruby'
          check 'all'
          click_button 'Search'

          within '.result_search' do
            expect(page).to_not have_content 'ruby'
            expect(page).to have_content 'Nothing found'
          end
        end
      end
    end
  end
end
