require 'rails_helper'

RSpec.describe Postman::NotifySubscribers do
  let(:users) { create_list(:user, 3) }
  let(:question) { create(:question) }
  let!(:subscriptions) do
    users.each do |user|
      Subscription.create(user: user, question: question)
    end
  end
  let(:answer) { create(:answer, question: question) }

  it 'sends new answer notify to all users' do
    users.each do |user|
      expect(NotifySubscribersMailer)
        .to receive(:notify).with(user, question, answer)
                            .and_call_original
    end

    subject.call(answer)
  end
end
