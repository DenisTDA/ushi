require 'rails_helper'

feature 'User can create vote', "
  In order to vote for intresting solutions 
  As an authenticated user
  I'd like to able to vote for answer or for question
" do
  given!(:user) { create(:user) }
  given(:friend) { create(:user) }
  given!(:question) { create(:question, author: friend)  }
  given!(:answer) { create(:answer, author: friend)  }
  given!(:vote){ create(:vote, voteable_type: question, voteable_id: question, voter_id: user)}

  describe 'Authenticated user have vote for a question and' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'reset the vote' do
      within '.question-block' do
        click_on 'reset'

        expect('.vote-block').to_not have_link 'reset'
        expect('.vote-block').to have_link 'useful'
        expect('.vote-block').to have_link 'useless'
      end
    end
  end
end
