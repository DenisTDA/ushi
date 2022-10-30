require 'rails_helper'

feature 'User can add links to answer', "
  In order to provide additional info to my answer
  As an question's author
  I'd like to able to add links
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  
  before do
    sign_in(user)
    visit question_path(question)
  end

  describe 'User adds' do
    given(:simple_link) { 'https://google.com' }
    given(:another_link) { 'https://yandex.ru' }

    before do
      fill_in 'Your answer', with: 'text text text'
      fill_in 'Link name', with: 'Google'
      fill_in 'Url', with: simple_link
    end

    scenario 'link when give an answer', js: true do
      click_on 'Answer'

      within ".answers" do
        expect(page).to have_link 'Google', href: simple_link
      end
    end

    scenario 'two links when give an answer', js: true do
      click_on 'add link'

      all(:field, 'Link name').last.fill_in with: 'Yandex'
      all(:field, 'Url').last.fill_in with: another_link

      click_on 'Answer'
      save_and_open_page

      within ".answers" do
        expect(page).to have_link 'Google', href: simple_link
        expect(page).to have_link 'Yandex', href: another_link
      end
    end
  end

  scenario 'User adds link with incorrect URL when give an answer', js: true do
    fill_in 'Your answer', with: 'text text text'
    fill_in 'Link name', with: 'My Gist'
    fill_in 'Url', with: 'wrongURL'

    click_on 'Answer'

    within ".answer-errors" do
      expect(page).to have_text 'Links url is invalid'
    end
  end

  scenario 'User adds link with gist when give an answer', js: true do
    fill_in 'Your answer', with: 'text text text'
    fill_in 'Link name', with: 'My Gist'
    
    fill_in 'Url', with: 'https://gist.github.com/DenisTDA/e0ad7f91d05dcf4f0cce8abdf6880be0'

    click_on 'Answer'

    within '.new-answer' do
      expect(page).to have_content 'test gist for Ushi application'
    end
  end
end
