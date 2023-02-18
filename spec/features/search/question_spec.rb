require 'sphinx_helper'

feature 'User can search for question', "
  In order to find needed question
  As a User
  I'd like to be able to search for the question
" do

  describe 'User searches for the question', js: true do
    
    given(:user) { create(:user) }
    given(:author) { create(:user, email: 'question@mail.com') }
    given!(:question1) { create(:question, title: 'title question', 
                                          body: '123') }
    given!(:question2) { create(:question, title: '123', 
                                          body: 'body question') }
    given!(:question3) { create(:question, title: '123', 
                                            body: '456',
                                            author: author) }

    scenario 'keyword into the title', sphinx: true do
      ThinkingSphinx::Test.run do
        visit query_new_path
        
        fill_in 'search', with: 'question'
        check 'subjects_question' 
        click_button 'Search'

        within '.result_search' do
          expect(page).to have_content 'title question'
        end
      end
    end

    scenario 'keyword into the body', sphinx: true do
      ThinkingSphinx::Test.run do
        visit query_new_path
        
        fill_in 'search', with: 'question'
        check 'subjects_question' 
        click_button 'Search'

        within '.result_search' do
          expect(page).to have_content 'body question'
        end
      end
    end

    scenario "keyword into the email's author", sphinx: true do
      ThinkingSphinx::Test.run do
        visit query_new_path
        
        fill_in 'search', with: 'question'
        check 'subjects_question' 
        click_button 'Search'

        within '.result_search' do
          expect(page).to have_content 'question@mail.com'
        end
      end
    end
  end

  describe 'User searches for the question, but ', js: true do
    given(:author) { create(:user, email: 'question@mail.com') }

    describe 'check invalid resources of a search' do
      given!(:question) { create(:question, title: 'question title', 
        body: 'question body',
        author: author) }

      scenario 'returns emty list', sphinx: true do
        ThinkingSphinx::Test.run do
          visit query_new_path
          
          fill_in 'search', with: 'question'
          check 'subjects_answer' 
          check 'subjects_comment' 
          click_button 'Search'

          within '.result_search' do
            expect(page).to_not have_content 'question'
            expect(page).to have_content 'Nothing found'
          end
        end
      end
    end
    
    describe 'not have questions in database with keyword' do
      given(:question) { create(:question) }
      given!(:answer) { create(:answer, body: 'question body',author: author) }
      given!(:comment) { create(:comment, body: 'question comment', 
                                          user: author,
                                          commentable: answer) }

      scenario 'returns empty list', sphinx: true do
        ThinkingSphinx::Test.run do
          visit query_new_path
          
          fill_in 'search', with: 'question'
          check 'subjects_question' 
          click_button 'Search'

          within '.result_search' do
            expect(page).to_not have_content 'question'
            expect(page).to have_content 'Nothing found'
          end
        end
      end
    end
  end
end
