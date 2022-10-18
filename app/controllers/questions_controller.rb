class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: %i[show destroy update]
  before_action :set_user, only: %i[index destroy update show]

  def index
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
    if current_user.author?(@question)
      @question.update(question_params)
    end
  end

  def show
    @answers = @question.answers.sort_by_best
    @answer = Answer.new
  end

  def destroy
    if current_user.author?(@question)
      @question.destroy
    end
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def set_user
    @user = current_user
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
