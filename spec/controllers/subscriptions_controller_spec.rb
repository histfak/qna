require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question) }

  describe 'POST #create' do
    context 'authenticated user' do
      before { login(user) }

      context 'not subscribed yet' do
        it 'creates a subscription' do
          expect { post :create, params: { question_id: question.id } }.to change(Subscription, :count).by(1)
        end

        it 'redirects to question show page' do
          post :create, params: { question_id: question.id }

          expect(response).to redirect_to assigns(:question)
        end
      end

      context 'already subscribed' do
        let!(:subscription) { create(:subscription, user: user, question: question) }

        it 'does not create a subscription' do
          expect { post :create, params: { question_id: question.id } }.to_not change(Subscription, :count)
        end

        it 'redirects to question show page' do
          post :create, params: { question_id: question.id }

          expect(response).to redirect_to assigns(:question)
        end
      end
    end

    context 'unauthenticated user' do
      it 'does not create a subscription' do
        expect { post :create, params: { question_id: question.id } }.to_not change(Subscription, :count)
      end

      it 'redirects to a root page' do
        post :create, params: { question_id: question.id }

        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:subscription) { create(:subscription, user: user, question: question) }

    context 'authenticated user' do
      before { login(user) }

      it 'deletes subscription' do
        expect { delete :destroy, params: { id: subscription.id } }.to change(Subscription, :count).by(-1)
      end

      it 'redirects to question show page' do
        delete :destroy, params: { id: subscription.id }

        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'unauthenticated user' do
      it 'does not delete a subscription' do
        expect { delete :destroy, params: { id: subscription.id } }.to_not change(Subscription, :count)
      end

      it 'redirects to a root page' do
        delete :destroy, params: { id: subscription.id }

        expect(response).to redirect_to root_path
      end
    end
  end
end
