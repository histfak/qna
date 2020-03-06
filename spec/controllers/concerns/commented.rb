require 'rails_helper'

shared_examples_for 'commented' do
  resource_factory = described_class.controller_name.classify.underscore.to_sym

  let!(:user) { create(:user) }
  let!(:resource) { create(resource_factory, user_id: user.id) }

  context 'Authenticated user' do
    describe "POST#create_comment" do
      before { login(user) }

      context 'adding a comment' do
        it 'assigns a commentable resource' do
          post :create_comment, params: { id: resource.id, comment: attributes_for(:comment) }, format: :json
          expect(assigns(:commentable)).to eq resource
        end

        it 'responds with json and success status' do
          post :create_comment, params: { id: resource.id, comment: attributes_for(:comment) }, format: :json
          expect(response.content_type).to eq 'application/json'
          expect(response).to be_successful
        end

        it 'creates a new instance of comment for commentable resource' do
          expect do
            post :create_comment, params: { id: resource.id, comment: attributes_for(:comment) }, format: :json
            resource.reload
          end.to change(resource.comments, :count).by(1)
        end
      end
    end
  end

  context 'Unauthenticated user' do
    describe "POST#create_comment" do
      context 'adding a comment' do
        it 'shows 401' do
          post :create_comment, params: { id: resource.id, comment: attributes_for(:comment) }, format: :json
          expect(response).to have_http_status(:unauthorized)
        end

        it 'doesnt create a new instance of comment for commentable resource' do
          expect do
            post :create_comment, params: { id: resource.id, comment: attributes_for(:comment) }, format: :json
            resource.reload
          end.not_to change(resource.comments, :count)
        end
      end
    end
  end
end
