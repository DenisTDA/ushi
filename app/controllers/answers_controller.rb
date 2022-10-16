class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_answer, only: %i[update select destroy]
  before_action :set_question, only: %i[index create]

  def index
    @user = current_user
    @answers = @question.answers
  end

  def new
    @user = current_user
    @answer = Answer.new
  end

  def create
    @answer = @question.answers.create(answer_params)
    current_user.replies << @answer
  end

  def show; end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def select
    @question = @answer.question
    if current_user.author?(@question.author_id)
      @answer.select_best
      flash[:notice] = 'New best answer is selected'
    else
      flash[:alert] = "It's not your question!"
    end
    redirect_to @question
  end

  def destroy
    @answer.destroy
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:id, :body, :question_id)
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end
end
