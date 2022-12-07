class CommentChannel < ApplicationCable::Channel
  def subscribed
    reject unless params[:commentable_id].present?
    stream_from "comment_channel_#{ params[:commentable_id] }"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    stop_all_streams
  end
end