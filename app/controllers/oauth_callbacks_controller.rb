class OauthCallbacksController < Devise::OmniauthCallbacksController
  skip_authorization_check
  
  def github
    authenticate_with('GitHub')
  end

  def google_oauth2
    authenticate_with('Google (google_oauth2)')
  end

  def mailru_oauth2
    authenticate_with('MailRu')
  end

  def vkontakte
    # render json: request.env['omniauth.auth']
    authenticate_with('VK')
  end

  private

  def authenticate_with(name_service)
    oauth = request.env['omniauth.auth']
    @user = User.find_for_oauth(oauth)

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: name_service) if is_navigational_format?
    elsif @user.nil? && !oauth.nil?
      session[:uid] = oauth.uid
      session[:provider] = oauth.provider
      redirect_to new_email_path
    else
      redirect_to root_path, alert: 'Somthing went wrong'
    end
  end
end
