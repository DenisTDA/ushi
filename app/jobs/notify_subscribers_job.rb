class NotifySubscribersJob < ApplicationJob
  queue_as :default

  def perform(object)
    Postman::NotifySubscribers.new.call(object)
  end
end
