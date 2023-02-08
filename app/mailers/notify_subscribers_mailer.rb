class NotifySubscribersMailer < ApplicationMailer
  def notify(subscriber, question, answer)
    @greeting = 'Hi'
    @subscriber = subscriber
    @question = question
    @answer = answer

    mail to: @subscriber.email, subject: 'You have got new answer'
  end
end
