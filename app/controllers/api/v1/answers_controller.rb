class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_question, only: %i[index]
  
  def index
    @answers = @question.answers
    render json: @answers, each_serializer: AnswersSerializer
  end

  def show
    @answer = Answer.find(params[:id])
    render json: @answer
  end

  private
  
  def set_question
    @question = Question.find(params[:question_id])
  end

end
