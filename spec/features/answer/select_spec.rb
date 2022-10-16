require 'rails_helper'

feature 'Author of the question can choose the best answer', "
  I, as authentication user and the author
  of the question, want to choose the best answer
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:answer1) { create(:answer, question: question) }
  given!(:answer2) { create(:answer, question: question) }
  given!(:answer_best) { create(:answer, selected: true, question: question) }

  background do
    sign_in(user)
    visit question_path(question)
    within(:id, "answer-block-#{answer1.id}") do
      click_on 'Mark as the best'
    end
  end

  scenario "Anauthenticated user, question's author choose the best" do
    elem1 = find_by_id("answer-block-#{answer2.id}")
    elem2 = find_by_id("answer-block-#{answer1.id}")

    expect(elem1).to have_content 'Mark as the best'
    expect(elem2).to_not have_content 'Mark as the best'
  end

  scenario "Anauthenticated user, question's author rechoose the best" do
    elem1 = find_by_id("answer-block-#{answer_best.id}")
    elem2 = find_by_id("answer-block-#{answer1.id}")

    expect(elem1).to have_content 'Mark as the best'
    expect(elem2).to_not have_content 'Mark as the best'
  end
end
