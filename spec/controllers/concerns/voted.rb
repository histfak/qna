require 'rails_helper'

shared_examples_for 'voted' do
  let!(:user) { create(:user) }
  resource_factory = described_class.controller_name.classify.underscore.to_sym
  let!(:resource) { create(resource_factory) }

  context 'Authenticated user' do
    before { login(user) }

    describe "PATCH#like" do
      it 'assigns a voting resource' do
        patch :like, params: { id: resource.id }, format: :json
        expect(assigns(:votable)).to eq resource
      end

      it 'responds with json and success status' do
        patch :like, params: { id: resource.id }, format: :json
        expect(response.content_type).to eq 'application/json'
        expect(response).to be_successful
      end

      it 'creates a new instance of vote for voting resource' do
        expect do
          patch :like, params: { id: resource.id }, format: :json
          resource.reload
        end.to change(resource.votes, :count).by(1)
      end
    end

    describe "PATCH#dislike" do
      it 'assigns a voting resource' do
        patch :dislike, params: { id: resource.id }, format: :json
        expect(assigns(:votable)).to eq resource
      end

      it 'responds with json and success status' do
        patch :dislike, params: { id: resource.id }, format: :json
        expect(response.content_type).to eq 'application/json'
        expect(response).to be_successful
      end

      it 'creates a new instance of vote for voting resource' do
        expect do
          patch :dislike, params: { id: resource.id }, format: :json
          resource.reload
        end.to change(resource.votes, :count).by(1)
      end
    end

    describe "PATCH#reset" do
      it 'assigns a voting resource' do
        patch :reset, params: { id: resource.id }, format: :json
        expect(assigns(:votable)).to eq resource
      end

      it 'responds with json and success status' do
        patch :reset, params: { id: resource.id }, format: :json
        expect(response.content_type).to eq 'application/json'
        expect(response).to be_successful
      end

      it 'creates a new instance of vote for voting resource' do
        expect do
          patch :reset, params: { id: resource.id }, format: :json
          resource.reload
        end.not_to change(resource.votes, :count)
      end
    end
  end

  context 'Unauthenticated user' do
    describe "PATCH#like" do
      it 'shows 401' do
        patch :like, params: { id: resource.id }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end

      it 'do not change anything' do
        expect do
          patch :like, params: { id: resource.id }, format: :json
          resource.reload
        end.not_to change(resource.votes, :count)
      end
    end

    describe "PATCH#dislike" do
      it 'shows 401' do
        patch :dislike, params: { id: resource.id }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end

      it 'do not change anything' do
        expect do
          patch :dislike, params: { id: resource.id }, format: :json
          resource.reload
        end.not_to change(resource.votes, :count)
      end

      describe "PATCH#reset" do
        it 'shows 401' do
          patch :reset, params: { id: resource.id }, format: :json
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end
end
