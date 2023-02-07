require 'rails_helper'

RSpec.describe NotifySubscribersJob, type: :job do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }
  let(:service) { double('Postman::NotifySubscribers') }

  before do
    allow(Postman::NotifySubscribers).to receive(:new).and_return(service)
  end

  it 'calls Postman::NotifySubscribers#call' do
    expect(service).to receive(:call).with(answer)
    NotifySubscribersJob.perform_now(answer)
  end
end
