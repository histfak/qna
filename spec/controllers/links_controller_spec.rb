require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let!(:user) { create(:user) }
  let!(:answer) { create(:answer, :with_links) }
  let!(:question) { create(:question, :with_links) }

  describe "DELETE#destroy" do
    context 'An author of the question deletes the question link' do
      before do
        login(question.author)
      end

      it 'deletes the link' do
        expect { delete :destroy, params: { id: question.links.first }, format: :js }.to change(Link, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: question.links.first }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'User tries to delete the question link which belongs to other user' do
      before do
        login(user)
      end

      it 'does not delete the link' do
        expect { delete :destroy, params: { id: question.links.first }, format: :js }.not_to change(Link, :count)
      end

      it 'returns 403' do
        delete :destroy, params: { id: question.links.first }, format: :js
        expect(response.content_type).to eq 'text/javascript'
        expect(response.status).to eq(403)
      end
    end

    context 'An author of the answer deletes the answer link' do
      before do
        login(answer.author)
      end

      it 'deletes the link' do
        expect { delete :destroy, params: { id: answer.links.first }, format: :js }.to change(Link, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: answer.links.first }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'User tries to delete the answer link which belongs to other user' do
      before do
        login(user)
      end

      it 'does not delete the link' do
        expect { delete :destroy, params: { id: answer.links.first }, format: :js }.not_to change(Link, :count)
      end

      it 'returns 403' do
        delete :destroy, params: { id: answer.links.first }, format: :js
        expect(response.content_type).to eq 'text/javascript'
        expect(response.status).to eq(403)
      end
    end

    context "Unauthenticated user tries to delete the link, the question's one" do
      it 'keeps the link' do
        expect { delete :destroy, params: { id: question.links.first }, format: :js }.not_to change(Link, :count)
      end

      it 'redirects to 401 page' do
        delete :destroy, params: { id: question.links.first }, format: :js
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "Unauthenticated user tries to delete the attached file, the answer's one" do
      it 'keeps the link' do
        expect { delete :destroy, params: { id: answer.links.first }, format: :js }.not_to change(Link, :count)
      end

      it 'redirects to 401 page' do
        delete :destroy, params: { id: answer.links.first }, format: :js
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
