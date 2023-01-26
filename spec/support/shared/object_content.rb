shared_examples_for 'Object containable' do
  context 'response' do
    it 'returns list of links' do
      expect(responce_object['links'].size).to eq object.links.count
    end

    it 'returns list of comments' do
      expect(responce_object['comments'].size).to eq object.comments.count
    end

    it 'returns list of attachments (files)' do
      expect(responce_object['files'].size).to eq object.files.count
    end

    it 'contains link object' do
      expect(responce_object['links'].first['id']).to eq object.links.first.id
    end

    it 'contains comment object' do
      expect(responce_object['comments'].first['id']).to eq object.comments.first.id
    end

    it 'contains file object' do
      expect(responce_object['files'].first['id']).to eq object.files.first.id
    end

    it 'contains file url_path' do
      expect(responce_object['files'].first['url_path'])
        .to eq Rails.application.routes.url_helpers.rails_blob_path(object.files.first, only_path: true)
    end
  end
end
