class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def unattach
    @file = ActiveStorage::Attachment.find(params[:id])
    holder = @file.record_type.constantize.find_by_id(params[:holder])
    @file.purge_later if current_user.author?(holder)
  end
end
