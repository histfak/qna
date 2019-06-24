require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { question.answers.create(body: "answer body") }

  describe 'GET #new' do
    before { login(user) }
    before { get :new, params: { question_id: question } }

    it 'assigns a new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(user) }
    context 'with valid attrs' do
      it 'saves a new answer in the database' do
        new_answer_attributes = attributes_for(:answer)
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to change(question.answers, :count).by(1)
        new_answer = question.answers.find_by! new_answer_attributes
        expect(user).to be_author(new_answer)
      end

      it 'renders create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attrs' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'registered users' do
      before { login(user) }

      context 'with valid user' do
        let!(:answer) { create(:answer, author: user) }

        it 'deletes the question' do
          expect { delete :destroy, params: { id: answer } }.to change(user.answers, :count).by(-1)
          expect { answer.reload }.to raise_error ActiveRecord::RecordNotFound
        end

        it 'redirects to index' do
          delete :destroy, params: { id: answer }
          expect(response).to redirect_to question_path(answer.question)
        end
      end

      context 'with invalid user' do
        let!(:answer) { create(:answer) }

        it 'keeps the question' do
          expect { delete :destroy, params: { id: answer } }.not_to change(Answer, :count)
        end

        it 'redirects back to question' do
          delete :destroy, params: { id: answer }
          expect(response).to redirect_to question_path(answer.question)
        end
      end
    end

    context 'with unauthenticated user' do
      let!(:answer) { create(:answer) }

      it 'keeps the question' do
        expect { delete :destroy, params: { id: answer } }.not_to change(Answer, :count)
      end

      it 'redirects to login page' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question, author: user) }

    context 'with valid attrs' do
      it 'changes answer attrs' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end
    context 'with invalid attrs' do
      it 'does not change answer attrs' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
  end
end
