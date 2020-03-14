require 'sidekiq/web'

Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  root to: 'questions#index'

  concern :votable do
    member do
      patch :like
      patch :dislike
      patch :reset
    end
  end

  concern :commentable do
    member { post :create_comment }
  end

  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, shallow: true, concerns: [:votable, :commentable], except: :index do
      patch 'best', on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        get :me, :others, on: :collection
      end
      resources :questions, only: [:index, :show, :create, :update, :destroy] do
        resources :answers, shallow: true, only: [:show, :create, :update, :destroy]
      end
    end
  end
end
