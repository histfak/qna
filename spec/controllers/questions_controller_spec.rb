require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  it_behaves_like 'voted'
  it_behaves_like 'commented'

  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns a new link to answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }
    before { get :new }

    it 'assigns a new question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assigns a new links to @question' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'assigns a new reward to @question' do
      expect(assigns(:question).reward).to be_a_new(Reward)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { login(user) }
    before { get :edit, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attrs' do
      it 'saves a new question in the database' do
        new_question_attributes = attributes_for(:question)
        expect { post :create, params: { question: new_question_attributes }, format: :js }.to change(Question, :count).by(1)
        new_question = user.questions.find_by! new_question_attributes
        expect(user).to be_author_of(new_question)
      end

      it 'creates a subscription for author' do
        expect { post :create, params: { question: attributes_for(:question) }, format: :js }.to change(Subscription, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }, format: :js
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attrs' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) }, format: :js }.to_not change(Question, :count)
      end

      it 're-renders create view' do
        post :create, params: { question: attributes_for(:question, :invalid) }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    let!(:question) { create(:question, author: user) }

    context 'with valid attrs' do
      it 'changes question attrs' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attrs' do
      before { login(user) }

      it 'does not change question attrs' do
        expect do
          patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
          question.reload
        end.to_not change(question, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with unauthenticated user' do
      let!(:question) { create(:question) }

      it 'keeps the question' do
        expect do
          patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
          question.reload
        end.to_not change(question, :body)
      end

      it 'redirects to main page' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(response.content_type).to eq 'text/javascript'
        expect(response.status).to eq(403)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'registered users' do
      before { login(user) }

      context 'with valid user' do
        let!(:question) { create(:question, author: user) }

        it 'deletes the question' do
          expect { delete :destroy, params: { id: question } }.to change(user.questions, :count).by(-1)
          expect { question.reload }.to raise_error ActiveRecord::RecordNotFound
        end

        it 'redirects to index' do
          delete :destroy, params: { id: question }
          expect(response).to redirect_to questions_path
        end
      end

      context 'with invalid user' do
        let!(:question) { create(:question) }

        it 'keeps the question' do
          expect { delete :destroy, params: { id: question } }.not_to change(Question, :count)
        end

        it 'redirects back to question' do
          delete :destroy, params: { id: question }
          expect(response).to redirect_to root_url
        end
      end
    end

    context 'with unauthenticated user' do
      let!(:question) { create(:question) }

      it 'keeps the question' do
        expect { delete :destroy, params: { id: question } }.not_to change(Question, :count)
      end

      it 'redirects to login page' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
