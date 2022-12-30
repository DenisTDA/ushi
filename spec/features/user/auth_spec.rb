require 'rails_helper'

feature 'User can register', "
  In order to ask questions
  As an registered user
  I'd like to be able to register
" do
  background { visit new_user_registration_path }

  describe 'Register with Omniauth services' do
    describe 'Github' do
      it 'user sign in with correct data' do
        visit new_user_registration_path
        expect(page).to have_content 'Sign in with GitHub'

        mock_auth_hash('github', email: 'user@test.com')
        click_link 'Sign in with GitHub'

        if page.has_content?('You have to confirm your email address before continuing')
          open_email('user@test.com')
          current_email.click_link 'Confirm my account'

          click_link 'Sign in with GitHub'
        end

        expect(page).to have_content 'Ask question'
        expect(page).to have_content 'Successfully authenticated from GitHub account.'
      end

      it 'can handle authentication error' do
        invalid_mock('github')
        visit new_user_registration_path
        expect(page).to have_content 'Sign in with GitHub'

        click_link 'Sign in with GitHub'

        expect(page).to have_content 'Could not authenticate you from GitHub because "Invalid credentials"'
      end
    end

    describe 'Vkontakte' do
      it 'user sign in with correct data without email' do
        visit new_user_registration_path
        expect(page).to have_content 'Sign in with Vkontakte'

        mock_auth_hash('vkontakte', email: nil)
        click_link 'Sign in with Vkontakte'

        fill_in 'Enter your e-mail', with: 'user@test.com'
        click_on 'Send confirmation to email'

        open_email('user@test.com')
        current_email.click_link 'Confirm my account'

        click_link 'Sign in with Vkontakte'

        expect(page).to have_content 'Ask question'
        expect(page).to have_content 'Successfully authenticated from VK account.'
      end

      it 'can handle authentication error' do
        invalid_mock('vkontakte')
        visit new_user_registration_path
        expect(page).to have_content 'Sign in with Vkontakte'

        click_link 'Sign in with Vkontakte'

        expect(page).to have_content 'Could not authenticate you from Vkontakte because "Invalid credentials"'
      end
    end
  end
end
