class QuestionsController < ApplicationController
  include Commented

  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: %i[show destroy update]

  after_action :publish_question, only: %i[create]

  authorize_resource

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
      @question.subscriptions.create(user: current_user)
      redirect_to @question, notice: 'Question successfully created'
    else
      render :new
    end
  end

  def update
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
    @question.destroy
  end

  private

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title,
                                     :body, files: [],
                                            links_attributes: %i[id name url _destroy],
                                            meed_attributes: %i[id name img _destroy])
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast('questions_channel',
                                 ApplicationController.render(
                                   partial: 'questions/question',
                                   locals: { question: @question, current_user: current_user }
                                 ))
  end
end
