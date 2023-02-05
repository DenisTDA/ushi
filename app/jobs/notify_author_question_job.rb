class NotifyAuthorQuestionJob < ApplicationJob
  queue_as :default

  def perform(object)
    Postman::NotifyAuthorQuestion.new.call(object)
  end
end
