Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  concern :votable do
    member do
      patch :like
      patch :dislike
      patch :reset
    end
  end

  resources :questions, concerns: [:votable] do
    resources :answers, shallow: true, concerns: [:votable], except: :index do
      patch 'best', on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index

  mount ActionCable.server => '/cable'
end
