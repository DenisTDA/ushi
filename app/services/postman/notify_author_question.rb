class Postman::NotifyAuthorQuestion < ApplicationService
  def call(answer)
    question = answer.question
    author = question.author
    NotifyAuthorQuestionMailer.notify(author, question, answer).deliver_later
  end
end
