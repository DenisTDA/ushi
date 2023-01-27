class AnswersChannel < ApplicationCable::Channel
  def subscribed
    reject if params[:question_id].blank?
    stream_from "answers_channel_#{params[:question_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    stop_all_streams
  end
end
