require 'rails_helper'

feature 'User can add links to question', "
  In order to provide additional info to my question
  As an question's author
  I'd like to able to add links
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  background do
    sign_in(user)
    visit new_question_path
  end

  describe 'User adds' do
    given(:simple_link) { 'https://google.com' }
    given(:another_link) { 'https://yandex.ru' }

    background do
      fill_in 'Title', with: 'title text'
      fill_in 'Body', with: 'body text'
      fill_in 'Link name', with: 'Google'
      fill_in 'Url', with: simple_link
    end

    scenario 'link when ask a question', js: true do
      click_on 'Publish'

      within '.question-block' do
        expect(page).to have_link 'Google', href: simple_link
      end
    end

    scenario 'two links when ask a question', js: true do
      click_on 'add link'

      all(:field, 'Link name').last.fill_in with: 'Yandex'
      all(:field, 'Url').last.fill_in with: another_link

      click_on 'Publish'

      within '.question-block' do
        expect(page).to have_link 'Google', href: simple_link
        expect(page).to have_link 'Yandex', href: another_link
      end
    end
  end

  scenario 'User adds link with incorrect URL when ask a question', js: true do
    fill_in 'Title', with: 'title text'
    fill_in 'Body', with: 'body text'
    fill_in 'Link name', with: 'My Gist'
    fill_in 'Url', with: 'wrongURL'

    click_on 'Publish'

    expect(page).to have_text 'Links url is invalid'
  end

  scenario 'User adds link with gist when ask a question', js: true do
    fill_in 'Title', with: 'title text'
    fill_in 'Body', with: 'body text'
    fill_in 'Link name', with: 'My Gist'
    fill_in 'Url', with: 'https://gist.github.com/DenisTDA/e0ad7f91d05dcf4f0cce8abdf6880be0'

    click_on 'Publish'

    within '.question-block' do
      expect(page).to have_content 'test gist for Ushi application'
    end
  end
end
