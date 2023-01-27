require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'return 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json['user'][attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not returns private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles/all' do
    let(:api_path) { '/api/v1/profiles/all' }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:users) { create_list(:user, 5) }
      let(:me) { users.first }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'return 200 status' do
        expect(response).to be_successful
      end

      it 'return list of profiles' do
        expect(json['users'].size).to eq users.count - 1
      end

      it 'does not return auth user' do
        users_id = json['users'].map { |user| user['id'] }

        expect(users_id).to_not include(me.id)
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json['users'].last[attr]).to eq users.last.send(attr).as_json
        end
      end

      it 'does not returns private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end
end
