class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_question, only: %i[index create]
  before_action :set_answer, only: %i[update destroy]

  authorize_resource

  def index
    @answers = @question.answers
    render json: @answers, each_serializer: AnswersSerializer
  end

  def show
    @answer = Answer.find(params[:id])
    render json: @answer
  end

  def create
    @answer = @question.answers.build(answer_params)
    current_resource_owner.replies << @answer
    if @answer.save
      render json: @answer, status: :created
    else
      render json: { errors: @answer.errors }, status: :bad_request
    end
  end

  def update
    if @answer.update(answer_params)
      render json: @answer, status: :accepted
    else
      render json: { errors: @answer.errors }, status: :bad_request
    end
  end

  def destroy
    @answer.destroy
    head :accepted
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
