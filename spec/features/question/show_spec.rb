require 'rails_helper'

feature 'User can observe the question with answers', %q{
  In order to observe the question user can select 
  the title of question and observe fool text of question
  with all answers
} do

  given!(:question) { create(:question) }
  given!(:answers) { create_list( :answer, 5, question_id: question.id) }  

  background { visit questions_path }

  scenario 'User select the question to observe' do
    click_on 'View'
    
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content question.answers.first.body
    expect(page).to have_content question.answers.last.body
  end
end
