require 'rails_helper'

feature 'User can add links to answer', "
  In order to provide additional info to my answer
  As an question's author
  I'd like to able to add links
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given(:gist_url) { 'https://gist.github.com/DenisTDA/f08301933493bd34831712c35896cfab' }

  scenario 'User adds links when create an answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Your answer', with: 'Answer text text text'
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url
    click_on 'Answer'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end
