require 'rails_helper'

feature 'User can see list of questions', %q{
  In order to choose a question 
  As a user
  I'd like to able to see list of titles of the questions
} do

  scenario 'User gets a list of questions' do
    questions = create_list(:question, 4)   
    visit questions_path(:questions)

    expect(page).to have_content questions[0].title
    expect(page).to have_content questions[1].title
    expect(page).to have_content questions[2].title
    expect(page).to have_content questions[3].title
  end
end 
