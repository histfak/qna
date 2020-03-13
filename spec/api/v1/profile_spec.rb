require 'rails_helper'

describe 'Profiles API', type: :request do
  PUBLIC_FIELDS = %w[id email admin created_at updated_at].freeze
  PRIVATE_FIELDS = %w[password encrypted_password].freeze

  let(:headers) {
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  }

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        PUBLIC_FIELDS.each do |attr|
          expect(json['user'][attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not return all private fields' do
        PRIVATE_FIELDS.each do |attr|
          expect(json['user']).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles/others' do
    let(:api_path) { '/api/v1/profiles/others' }
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:me) { create(:user) }
      let!(:others) { create_list(:user, 3) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'does not contain resource owner' do
        json['users'].each do |user|
          expect(user['id']).not_to eq me.id
        end
      end

      it 'returns all public fields' do
        PUBLIC_FIELDS.each do |attr|
          expect(json['users'].first[attr]).to eq others.first.send(attr).as_json
        end
      end

      it 'does not return all private fields' do
        PRIVATE_FIELDS.each do |attr|
          expect(json['users'].first).to_not have_key(attr)
        end
      end
    end
  end
end
