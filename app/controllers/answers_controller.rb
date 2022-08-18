class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: %i[index create]

  def index
    @answers = @question.answers
  end

  def new
    @answer = Answer.new
  end

  def create
    @answer = @question.answers.create(answer_params)
    current_user.replies << @answer

  end

  def show; end

  def update
    @answer = Answer.find(params[:id])
    @answer.update(answer_params)
    @question = @answer.question    
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:id, :body, :question_id)
  end
end
