class UsersController < ApplicationController
  skip_authorization_check
  
  def new_email
    @user = User.new
  end

  def confirm_email
    password = Devise.friendly_token[0, 20]
    @user = User.create!(email: email_params[:email], password: password, password_confirmation: password)
    @user.authorizations.create!(provider: session[:provider], uid: session[:uid])
    redirect_to root_path, alert: 'Your account successfully created! Please confirm your email!'
  end

  private

  def email_params
    params.require(:user).permit(:email)
  end
end
