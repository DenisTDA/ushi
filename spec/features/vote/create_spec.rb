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

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'vote for a question - useful' do
      within '.question-block' do
        click_on 'useful'

        expect('.vote-block').to have_link 'reset'
        expect('.vote-block').to_not have_link 'useful'
        expect('.vote-block').to_not have_link 'useless'
      end
    end

    scenario 'vote for a question - useless' do
      within '.question-block' do
        click_on 'useless'

        expect('.vote-block').to have_link 'reset'
        expect('.vote-block').to_not have_link 'useful'
        expect('.vote-block').to_not have_link 'useless'
      end
    end
  end
end
