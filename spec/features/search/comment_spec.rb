require 'sphinx_helper'

feature 'User can search for comment', "
  In order to find needed answer
  As a User
  I'd like to be able to search for the answer
" do
  given(:user) { create(:user) }

  describe 'User searches for the comment', js: true do
    given(:author) { create(:user, email: 'comment@mail.com') }
    given(:question){ create(:question) }
    given!(:comment2) { create(:comment, body: 'body comment', commentable: question, user: user) }
    given!(:comment3) { create(:comment, body: '456', commentable: question, user: author) }

    scenario 'keyword into the body', sphinx: true do
      ThinkingSphinx::Test.run do
        visit query_new_path
        
        fill_in 'search', with: 'comment'
        check 'subjects_comment' 
        click_button 'Search'

        within '.result_search' do
          expect(page).to have_content 'body comment'
        end
      end
    end

    scenario "keyword into the email's author", sphinx: true do
      ThinkingSphinx::Test.run do
        visit query_new_path
        
        fill_in 'search', with: 'comment'
        check 'subjects_comment' 
        click_button 'Search'

        within '.result_search' do
          expect(page).to have_content 'comment@mail.com'
        end
      end
    end
  end

  describe 'User searches for the comment, but ', js: true do
    given(:author) { create(:user, email: 'comment@mail.com') }
    given(:question) { create(:question) }

    describe 'check invalid resources of a search' do
      given!(:comment) { create(:comment,
                                body: 'comment body',
                                commentable: question,
                                user: author) }

      scenario 'returns emty list', sphinx: true do
        ThinkingSphinx::Test.run do
          visit query_new_path
          
          fill_in 'search', with: 'comment'
          check 'subjects_question' 
          check 'subjects_answer' 
          click_button 'Search'

          within '.result_search' do
            expect(page).to_not have_content 'comment'
            expect(page).to have_content 'Nothing found'
          end
        end
      end
    end
    
    describe 'not have comments in database with keyword' do
      given!(:answer) { create(:answer) }
      given!(:comment) { create(:comment, commentable: answer, user: user) }
      given!(:question) { create(:question, title: 'question title comment', 
                                            body: 'question body comment',  
                                            author: author) }
      given!(:answer1) { create(:answer, body: 'answer comment', author: author ) }

      scenario 'returns empty list', sphinx: true do
        ThinkingSphinx::Test.run do
          visit query_new_path
          
          fill_in 'search', with: 'comment'
          check 'subjects_comment'
          click_button 'Search'

          within '.result_search' do
            expect(page).to_not have_content 'comment'
            expect(page).to have_content 'Nothing found'
          end
        end
      end
    end
  end
end
