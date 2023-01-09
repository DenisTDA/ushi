class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    holder = @file.record
    authorize! :destroy, @file
    @file.purge_later
  end
end
