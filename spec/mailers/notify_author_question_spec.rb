require "rails_helper"

RSpec.describe NotifyAuthorQuestionMailer, type: :mailer do
  describe "notify" do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }
    let(:answer) { create(:answer, question: question)}
    let(:mail) { NotifyAuthorQuestionMailer.notify(user, question, answer) }

    it "renders the headers" do
      expect(mail.subject).to eq("You have got new answer")
      expect(mail.to).to eq([user.email]    )
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(answer.body)
    end
  end
end
  