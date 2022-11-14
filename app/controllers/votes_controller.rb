class VotesController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @vote = @voteable.votes.new vote_params
    @vote.voter = current_user
    respond_to do |format|
      if @vote.save
        format.json {render json: @vote}
      else
        format.json do
          render json: @vote.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
    
    
  end

  def destroy
    @vote = Vote.find(params[:id])
    @vote.destroy
  end

  private

  def vote_params
    params.require(:vote).permit(:useful)
  end
end
