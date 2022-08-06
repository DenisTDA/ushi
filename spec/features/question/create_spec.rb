require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from community
  As a user
  I'd like to able to ask question
} do
  background {
    visit questions_path
    click_on "Ask question"
  }

  scenario 'User asks a question' do
    fill_in "Title", with: 'Test question'
    fill_in "Body", with: 'text text text'
    click_on 'Publish'

    expect(page).to have_content 'Question successfully created'
    expect(page).to have_content 'Test question'
    expect(page).to have_content 'text text text'
  end

  scenario 'User asks a question with errors' do
    click_on 'Publish'

    expect(page).to have_content "Title can't be blank"
  end
end 
