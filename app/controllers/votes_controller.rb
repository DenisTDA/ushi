class VotesController < ApplicationController
  before_action :authenticate_user!

  def create
    @vote = @voteable.votes.new vote_params
    @vote.voter = current_user unless current_user.author?(@voteable)
    respond_to do |format|
      if @vote.save
        format.json { render json: [@vote, @voteable.rating] }
      else
        format.json do
          render json: @vote.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    @vote = Vote.find(params[:id])
    @voteable = @vote.voteable
    respond_to do |format|
      if @vote.destroy
        format.json { render json: ['', @voteable.rating] }
      else
        format.json do
          render  json: @vote.errors.full_messages, 
                  status: :unprocessable_entity
        end
      end
    end
  end

  private

  def vote_params
    params.require(:vote).permit(:useful)
  end
end
