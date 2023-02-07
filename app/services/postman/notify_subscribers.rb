class Postman::NotifySubscribers < ApplicationService
  def call(answer)
    question = answer.question
    question.subscriptions.map(&:user).each do |user|
      NotifySubscribersMailer.notify(user, question, answer).deliver_later
    end
  end
end
