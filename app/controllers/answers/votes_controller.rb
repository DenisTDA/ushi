class Answers::VotesController < VotesController
  before_action :set_voteable

  private

  def set_voteable
    @voteable = Answer.find(params[:answer_id]) if params[:answer_id]
  end
end
