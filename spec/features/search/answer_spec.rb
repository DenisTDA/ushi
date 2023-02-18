require 'sphinx_helper'

feature 'User can search for answer', "
  In order to find needed answer
  As a User
  I'd like to be able to search for the answer
" do

  describe 'User searches for the answer', js: true do
    
    given(:user) { create(:user) }
    given(:author) { create(:user, email: 'answer@mail.com') }
    given!(:answer2) { create(:answer, body: 'body answer') }
    given!(:answer3) { create(:answer, body: '456', author: author) }

    scenario 'keyword into the body', sphinx: true do
      ThinkingSphinx::Test.run do
        visit query_new_path
        
        fill_in 'search', with: 'answer'
        check 'subjects_answer' 
        click_button 'Search'

        within '.result_search' do
          expect(page).to have_content 'body answer'
        end
      end
    end

    scenario "keyword into the email's author", sphinx: true do
      ThinkingSphinx::Test.run do
        visit query_new_path
        
        fill_in 'search', with: 'answer'
        check 'subjects_answer' 
        click_button 'Search'

        within '.result_search' do
          expect(page).to have_content 'answer@mail.com'
        end
      end
    end
  end

  describe 'User searches for the answer, but ', js: true do
    given(:author) { create(:user, email: 'answer@mail.com') }

    describe 'check invalid resources of a search' do
      given!(:answer) { create(:answer,
                                body: 'question body',
                                author: author) }

      scenario 'returns emty list', sphinx: true do
        ThinkingSphinx::Test.run do
          visit query_new_path
          
          fill_in 'search', with: 'answer'
          check 'subjects_question' 
          check 'subjects_comment' 
          click_button 'Search'

          within '.result_search' do
            expect(page).to_not have_content 'answer'
            expect(page).to have_content 'Nothing found'
          end
        end
      end
    end
    
    describe 'not have answers in database with keyword' do
      given(:answer) { create(:answer) }
      given!(:question) { create(:question, title: 'question title answer', 
                                            body: 'question body answer',  
                                            author: author) }
      given!(:comment) { create(:comment, body: 'answer comment', 
                                          user: author,
                                          commentable: answer) }

      scenario 'returns empty list', sphinx: true do
        ThinkingSphinx::Test.run do
          visit query_new_path
          
          fill_in 'search', with: 'answer'
          check 'subjects_answer' 
          click_button 'Search'

          within '.result_search' do
            expect(page).to_not have_content 'answer'
            expect(page).to have_content 'Nothing found'
          end
        end
      end
    end
  end
end
