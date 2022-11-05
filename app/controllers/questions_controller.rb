class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: %i[show destroy update]
  before_action :set_user, only: %i[index destroy update show]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
    @question.links.new
    @question.build_meed
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
    return unless current_user.author?(@question)

    @question.update(title: question_params[:title],
                     body: question_params[:body],
                     links_attributes: question_params[:links_attributes] || [])
    @question.files.attach(question_params[:files]) if question_params[:files]
  end

  def show
    @answers = @question.answers.sort_by_best
    @answer = Answer.new
    @answer.links.new
  end

  def destroy
    @question.destroy if current_user.author?(@question)
  end

  private

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def set_user
    @user = current_user
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                                    links_attributes: %i[id name url _destroy],
                                                    meed_attributes: %i[id name img _destroy])
  end
end
