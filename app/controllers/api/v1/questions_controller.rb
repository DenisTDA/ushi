class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :set_question, only: %i[show update]
  skip_before_action :verify_authenticity_token


  def index
    @questions = Question.all
    render json: @questions, each_serializer: QuestionsSerializer
  end

  def show
    render json: @question
  end

  def create
    @question = current_resource_owner.problems.build(question_params)
    if @question.save
      render json: @question, status: :created
    else
      render json: { errors: @question.errors }, status: :bad_request
    end
  end

  def update
    if @question.update(question_params)
      render json: @question, status: :ok
    else   
      render json: { errors: @question.errors }, status: :bad_request
    end 
  end

  private

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end

end
