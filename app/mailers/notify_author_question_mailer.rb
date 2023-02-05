class NotifyAuthorQuestionMailer < ApplicationMailer
  def notify(author, question, answer)
    @greeting = "Hi" 
    @author = author
    @question = question
    @answer = answer

    mail to: @author.email, subject: 'You have got new answer'
  end
end
  