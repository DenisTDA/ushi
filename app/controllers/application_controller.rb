require 'gon'

class ApplicationController < ActionController::Base
  before_action :gon_user, unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end

  check_authorization unless: :devise_controller?

  private

  def gon_user
    # -1 value for non-auth users
    gon.user_id = current_user&.id || -1
  end
end
