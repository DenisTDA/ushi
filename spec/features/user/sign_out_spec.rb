require 'rails_helper'

feature 'User can sign out', "
  In order to quit from system
  As an authenticated user
  I'd like to be able to sign out
" do
  given(:user) { User.create!(email: 'user@test.com', password: '123456') }

  background { visit new_user_session_path }

  scenario 'Registered user sign in and then tries to sign out' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
