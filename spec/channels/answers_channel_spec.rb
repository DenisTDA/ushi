require 'rails_helper'

RSpec.describe AnswersChannel, type: :channel do
  let(:channel_name) { 'answers_channel_1' }

  it_behaves_like 'subscribeable'
end
