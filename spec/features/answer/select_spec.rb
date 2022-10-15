require 'rails_helper'

feature  'Author of the question can choose the best answer',
  "I, as authentication user and the author 
  of the question, want to choose the best answer"
  do
  given(:user) { create(:user) }
  given(:question) { create(:question, author_id: user) }
  given!(:answers) { create_list(:answer, 5, question: question, author: user) }
  given!(:answer_best) { create(:answer, selected: true, question_id: question.id) }

  background do
    sign_in(user)
    visit question_path(question)
    within(:id, "answer-block-#{answers[3].id}") do
      click_on 'Mark as the best answer'
    end 
  end

  scenario "Anauthenticated user, question's author choosethe best answer", js: true do
 
#    expect(page).to_not have_link 'Edit'
  end

end
