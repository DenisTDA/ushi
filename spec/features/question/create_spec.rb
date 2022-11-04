require 'rails_helper'

feature 'User can create question', "
  In order to get answer from community
  As an authenticated user
  I'd like to able to ask question
" do
  given(:user) { create(:user) }
  given(:friend) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'asks a question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      click_on 'Publish'

      expect(page).to have_content 'Question successfully created'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
    end

    scenario 'asks a question with errors' do
      click_on 'Publish'

      expect(page).to have_content "Title can't be blank"
    end

    scenario 'asks a question with attached files' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      attach_file 'Files', [Rails.root.join('spec/rails_helper.rb'), Rails.root.join('spec/spec_helper.rb')]
      click_on 'Publish'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'asks a question & create meed' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      fill_in 'Meed', with: 'text text text'
      attach_file 'Image', Rails.public_path.join('images/batfly1.png')

      click_on 'Publish'

      expect(page).to have_content 'Question successfully created'
    end
  end

  scenario 'Unauthenticated user asks a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
