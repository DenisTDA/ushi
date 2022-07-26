class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    holder = @file.record
    @file.purge_later if current_user.author?(holder)
  end
end
