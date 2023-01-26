require 'rails_helper'

RSpec.describe CommentChannel, type: :channel do
  let(:channel_name) { 'comment_channel_1' }

  it_behaves_like 'subscribeable'
end
