require 'rails_helper'

RSpec.describe NotifyAuthorQuestionJob, type: :job do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }
  let(:service) { double ('Postman::NotifyAuthorQuestion') }

  before do
    allow(Postman::NotifyAuthorQuestion).to receive(:new).and_return(service)
  end

  it 'calls Postman::NotifyAuthorQuestion#call' do
    expect(service).to receive(:call).with(answer)
    NotifyAuthorQuestionJob.perform_now(answer)
  end
end
