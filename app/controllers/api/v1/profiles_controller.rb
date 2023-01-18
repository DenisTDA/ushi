class Api::V1::ProfilesController < Api::V1::BaseController

  def me
    render json: current_resource_owner, serializer: ProfileSerializer 
  end

  def all
    @profiles = User.where.not(id: current_resource_owner.id)
    render json: @profiles, each_serializer: ProfileSerializer  
  end

end
