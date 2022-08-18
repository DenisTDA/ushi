class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: %i[show destroy edit]

  def index
    @user = current_user
    @questions = Question.all
  end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.problems.build(question_params)

    if @question.save
      redirect_to @question, notice: 'Question successfully created'
    else
      render :new
    end
  end

  def update
  end

  def show
    @answer = Answer.new
  end

  def destroy
    if @question.own?(current_user)
      @question.destroy
      flash[:notice] = 'Question successfully deleted'
    else
      flash[:notice] = "Question can't be deleted"
    end
    redirect_to action: :index
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
