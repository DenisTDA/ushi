require 'rails_helper'

RSpec.describe CommentChannel, type: :channel do
  it 'successfully subscribes' do
    subscribe question_id: 1
    expect(subscription).to be_confirmed
  end

  it 'rejects subscription' do
    subscribe question_id: nil
    expect(subscription).to be_rejected
  end

  it 'successfully subscribes' do
    subscribe question_id: 1
    expect(subscription).to have_stream_from('comment_channel_1')
  end
end
