require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe "GET #search" do
    context 'authenticated user' do
      let(:user) { create(:user) }
      let(:questions) { create_list(:question, 3) }

      before do
        login(user)
        get :search, params: { 'query' => 'phrase', 'search_type' => 'All' }
      end

      it "returns OK" do
        expect(response).to have_http_status(:success)
      end

      it "renders search view" do
        expect(response).to render_template 'search/show'
      end
    end

    context 'unauthenticated user' do
      before do
        get :search, params: { 'query' => 'phrase', 'search_type' => 'All' }
      end

      it "returns 302" do
        expect(response).to have_http_status(:redirect)
      end

      it "redirects to index" do
        expect(response).to redirect_to root_path
      end
    end
  end
end
