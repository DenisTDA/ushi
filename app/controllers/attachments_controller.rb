class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  
  #skip_authorization_check
  
    
  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    holder = @file.record
    authorize! :destroy, @file
    @file.purge_later #if current_user.author?(holder)
  end
end
