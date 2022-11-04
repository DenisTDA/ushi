class MeedsController < ApplicationController
  before_action :authenticate_user!, only: %i[index]

  def index
    @meeds = Meed.of_user(current_user)
  end
end
