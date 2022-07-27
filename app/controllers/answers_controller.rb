class AnswersController < ApplicationController
  before_action :set_question, only: :list
  
  def list
    @answers = @question.answers
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:id, :body, :question_id)
  end
end
