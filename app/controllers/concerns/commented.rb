module Commented
  extend ActiveSupport::Concern

  included do
    before_action :set_commentable, only: %i[comment show]
  end

  def comment
    authenticate_user!
    @comment = @commentable.comments.new(commentable_params)
    @comment.assign_attributes(user: current_user)

    respond_to do |format|
      if @comment.save
        format.json do 
          render json: [comment: @comment, user_email: current_user.email] 
        end
      else
        format.json do
          render  json: [comment: @comment,
                        errors: @comment.errors.full_messages], 
                  status: :unprocessable_entity,
                  status: :created
        end
      end
    end
    publish_comment
  end

  private 

  def model_klass
    controller_name.classify.constantize
  end

  def set_commentable
    @commentable = model_klass.find(params[:id])
  end

  def commentable_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    if @comment.errors.empty?    
      ActionCable.server.broadcast("comment_channel_#{ @commentable.id }",
                                        comment: @comment.body,
                                        email: current_user.email)
    end
  end
end
