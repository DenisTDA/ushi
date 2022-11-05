require 'rails_helper'

feature 'User can see list of meeds', "
  In order to choose a question
  As a authenticated user
  I'd like to able to see list of achivements (meeds)
" do
  given!(:user) { create(:user) }
  given!(:friend) { create(:user) }
  given!(:question1) { create(:question, author: friend) }
  given!(:question2) { create(:question, author: friend) }
  given!(:answer1) { create(:answer, author: user, question: question1) }
  given!(:answer2) { create(:answer, author: user, question: question2) }
  given!(:meed1) { create(:meed, question: question1) }
  given!(:meed2) { create(:meed, question: question2) }
  given!(:file1) { Rack::Test::UploadedFile.new(Rails.public_path.join('images/batfly1.png')) }

  scenario 'User gets a list of meeds' do
    meed1.img.attach(file1)
    meed2.img.attach(file1)
    answer1.select_best
    answer2.select_best

    sign_in(user)

    click_on 'List of Meeds'

    expect(page).to have_content question1.title
    expect(page).to have_content question2.title
  end

  scenario "User (have't meeds) don't see  a list of meeds" do
    meed1.img.attach(file1)
    meed2.img.attach(file1)
    answer1.select_best
    answer2.select_best

    sign_in(friend)

    click_on 'List of Meeds'

    expect(page).to_not have_content question1.title
    expect(page).to_not have_content question2.title
  end
end
