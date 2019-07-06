require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:answer) { create(:answer, :with_files) }
  let(:question) { create(:question, :with_files) }

  describe "DELETE#destroy" do
    context 'An author of the question deletes the attached file' do
      before do
        login(question.author)
        delete :destroy, params: { id: question.files.first }, format: :js
      end

      it 'deletes the attached file' do
        expect(question.reload.files).to_not be_attached
      end

      it 'renders destroy view' do
        expect(response).to render_template :destroy
      end
    end

    context 'User tries to delete the file which belongs to other user' do
      before do
        login(user)
        delete :destroy, params: { id: question.files.first }, format: :js
      end

      it 'does not delete the attached file' do
        expect(question.reload.files).to be_attached
      end

      it 'renders destroy view' do
        expect(response).to render_template :destroy
      end
    end

    context 'An author of the answer deletes the attached file' do
      before do
        login(answer.author)
        delete :destroy, params: { id: answer.files.first }, format: :js
      end

      it 'deletes the attached file' do
        expect(answer.reload.files).to_not be_attached
      end

      it 'renders destroy view' do
        expect(response).to render_template :destroy
      end
    end

    context 'User tries to delete the attached file which belongs to other user' do
      before do
        login(user)
        delete :destroy, params: { id: answer.files.first }, format: :js
      end

      it 'does not delete the attached file' do
        expect(answer.reload.files).to be_attached
      end

      it 'renders destroy view' do
        expect(response).to render_template :destroy
      end
    end

    context "Unauthenticated user tries to delete the attached file, the question's one" do
      it 'keeps the file' do
        expect do
          delete :destroy, params: { id: question.files.first }, format: :js
          question.reload
        end.to_not change(question, :files)
      end

      it 'redirects to 401 page' do
        delete :destroy, params: { id: question.files.first }, format: :js
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "Unauthenticated user tries to delete the attached file, the answer's one" do
      it 'keeps the file' do
        expect do
          delete :destroy, params: { id: answer.files.first }, format: :js
          answer.reload
        end.to_not change(answer, :files)
      end

      it 'redirects to 401 page' do
        delete :destroy, params: { id: answer.files.first }, format: :js
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
