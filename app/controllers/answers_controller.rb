class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_answer, only: %i[update select destroy unattach]
  before_action :set_question, only: %i[index create]

  def index
    @answers = @question.answers
  end

  def new
    @answer = Answer.new
    @answer.links.new
  end

  def create
    @answer = @question.answers.build(answer_params)
    current_user.replies << @answer
    @answer.save
  end

  def show; end

  def update
    if current_user.author?(@answer)
      @answer.update(body: answer_params[:body])
      @answer.files.attach(answer_params[:files]) if answer_params[:files]
      @question = @answer.question
    else
      flash[:alert] = "It's not your answer!"
    end
  end

  def select
    @question = @answer.question
    if current_user.author?(@question)
      @answer.select_best
      flash[:notice] = 'New best answer is selected'
    else
      flash[:alert] = "It's not your answer!"
    end
    redirect_to @question
  end

  def destroy
    @answer.destroy if current_user.author?(@answer)
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:id, :body, :question_id, files: [],
                                                             links_attributes: %i[id name url _destroy])
  end

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end
end
