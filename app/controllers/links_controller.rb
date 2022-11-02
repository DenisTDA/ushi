class LinksController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @link = Link.find(params[:id])
    holder = @link.linkable

    @link.destroy if current_user.author?(holder)
  end

  private

end
