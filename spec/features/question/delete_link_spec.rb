require 'rails_helper'

feature 'User can delete links of a question', "
  In order to delete useless info of my question
  As a question's author
  I'd like to able to delete links
" do
  given!(:user) { create(:user) }
  given!(:friend) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:link1) { create(:link, name: 'Google', url: 'http://gogle.com',linkable: question) }
  given!(:link2) { create(:link, name: 'E1', linkable: question) }


  describe 'Authenticated user-author', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end
  
    scenario 'delete link' do
      first(:link,'delete link').click
      accept_alert

      within ".links-block" do
        expect(page).to_not have_link 'Google', href: link1.url
        expect(page).to_not have_link 'E1', href: link2.url
      end
    end
  end

  describe 'Unauthenticated user', js: true do
    background do
      sign_in(friend)
      visit question_path(question)
    end

    scenario "don't see 'delete link' " do
      expect(page).to_not have_content 'delete link'
    end
  end
end
