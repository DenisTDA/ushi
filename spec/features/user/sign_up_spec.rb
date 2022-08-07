require 'rails_helper'

feature 'User can sign up', "
  In order to have more possibilities
  for ask, answer, delete, edit 
  As an unauthenticated user
  I'd like to be able to authenticate and sign in
" do
  background { visit new_user_registration_path }

  scenario 'Unauthenticated user tries to sign up' do
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content "Welcome! You have signed up successfully."
  end

  scenario 'Unauthenticated user tries to sign up without email' do
    click_on 'Sign up'

    expect(page).to have_content "Email can't be blank"
  end

  scenario 'Unauthenticated user tries to sign up without password' do
    click_on 'Sign up'

    expect(page).to have_content "Password can't be blank"
  end

  scenario 'Unauthenticated user tries to sign up with wrong confirmation' do
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: 'qwertyui'
    click_on 'Sign up'

    expect(page).to have_content "Password confirmation doesn't match Password"
  end

  scenario 'Authenticated user tries to sign up' do
    User.create!(email: 'user@test.com', password: '12345678', password_confirmation: '12345678')
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content "this user from being saved"
  end

  scenario 'Unauthenticated user tries to sign up with occupied email' do
    User.create!(email: 'user@test.com', password: '12345678', password_confirmation: '12345678')
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '87654321'
    fill_in 'Password confirmation', with: '87654321'
    click_on 'Sign up'

    expect(page).to have_content "Email has already been taken"
  end

end
