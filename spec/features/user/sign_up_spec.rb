require 'rails_helper'

feature 'User can sign up', "
  In order to have more possibilities
  for ask, answer, delete, edit
  As an unauthenticated user
  I'd like to be able to authenticate and sign in
" do
  background { visit new_user_registration_path }

  scenario 'Unregistered user tries to sign up' do
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    if page.has_content?('Please follow the link to activate your account')
      open_email('user@test.com')
      current_email.click_link 'Confirm my account'

      click_link 'Entry'

      fill_in 'Email', with: 'user@test.com'
      fill_in 'Password', with: '12345678'
      click_on 'Log in'
    end

    expect(page).to have_content 'Signed in successfully'
  end

  scenario 'Unregistered user tries to sign up without email' do
    click_on 'Sign up'

    expect(page).to have_content "Email can't be blank"
  end

  scenario 'Unregistered user tries to sign up without password' do
    click_on 'Sign up'

    expect(page).to have_content "Password can't be blank"
  end

  scenario 'Unregistered user tries to sign up with wrong confirmation' do
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: 'qwertyui'
    click_on 'Sign up'

    expect(page).to have_content "Password confirmation doesn't match Password"
  end

  scenario 'Unregistered user tries to sign up with occupied email' do
    User.create!(email: 'user@test.com', password: '12345678', password_confirmation: '12345678')
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '87654321'
    fill_in 'Password confirmation', with: '87654321'
    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end

  scenario 'Authenticated user tries to sign up' do
    User.create!(email: 'user@test.com', password: '12345678', password_confirmation: '12345678')
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'this user from being saved'
  end
end
