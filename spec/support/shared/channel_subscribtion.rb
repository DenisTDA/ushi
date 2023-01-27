shared_examples_for 'subscribeable' do
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

    expect(subscription).to have_stream_from(channel_name)
  end
end
