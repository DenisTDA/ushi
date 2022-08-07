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
    @answer = @question.answers.build(answer_params)

    if @answer.save
      redirect_to @question, notice: 'Answer successfully created'
    else
      redirect_to @question, alert: "Answer's body can't be be blank"
    end
  end

  def show; end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:id, :body, :question_id)
  end
end
