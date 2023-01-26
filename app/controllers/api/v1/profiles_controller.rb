class Api::V1::ProfilesController < Api::V1::BaseController

  def me
    authorize! :me, current_resource_owner 
    render json: current_resource_owner, serializer: ProfileSerializer 
  end

  def all
    authorize! :all, current_resource_owner 
    @profiles = User.where.not(id: current_resource_owner.id)
    render json: @profiles, each_serializer: ProfileSerializer  
  end
end
