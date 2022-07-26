require 'rails_helper'

feature 'User can observe the question with answers', '
  In order to observe the question user can select
  the title of question and observe fool text of question
  with all answers
' do
  describe 'Any user', js: true do
    given(:question) { create(:question) }
    given!(:answers) { create_list(:answer, 5, question_id: question.id) }
    given!(:answer_best) { create(:answer, body: 'The Best Answer', selected: true, question: question) }

    background do
      visit questions_path
      click_on 'View'
    end

    scenario 'select the question to observe' do
      expect(page).to have_content question.title
      expect(page).to have_content question.body
      expect(page).to have_content question.answers.first.body
      expect(page).to have_content question.answers.last.body
    end

    scenario 'select the question and the best answer is rendered first' do
      elem = find(:id, /answer-block-\d{1,}/, match: :first)
      expect(elem).to match(find_by_id("answer-block-#{answer_best.id}"))
    end

    scenario "can't select the best answer, because hi is't the author of the question" do
      expect(page).to_not have_content 'Mark as the best'
    end
  end

  describe 'Authenticated user - author of the question', js: true do
    given(:user) { create(:user) }
    given(:question) { create(:question, author: user) }
    given!(:answers) { create_list(:answer, 5, question: question) }
    given!(:answer_best) { create(:answer, selected: true, question: question) }

    background do
      sign_in(user)
      visit questions_path
      click_on 'View'
    end

    scenario "can't select the best answer again" do
      elem = find_by_id("answer-block-#{answer_best.id}")

      expect(elem).to_not have_content 'Mark as the best'
    end

    scenario 'see the link to choose the best answer' do
      expect(find_all(:link, 'Mark as the best').count).to match 5
    end
  end
end
