require 'rails_helper'

feature 'User can add links to question', "
  In order to provide additional info to my question
  As an question's author
  I'd like to able to add links
" do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/DenisTDA/f08301933493bd34831712c35896cfab' }

  scenario 'User addslinks when ask question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Publish'
    expect(page).to have_link 'My gist', href: gist_url
  end
end
