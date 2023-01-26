class Api::V1::BaseController < ApplicationController
  before_action :doorkeeper_authorize!

  rescue_from CanCan::AccessDenied do |exception|
    render json: { errors: exception }, status: :forbidden
  end

  private

  def current_user
    return current_resource_owner if doorkeeper_token

    warden.authenticate(scope: :user)
  end

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
