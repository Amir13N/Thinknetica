# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  devise_scope :user do
    get 'email_confirmation', to: 'oauth_callbacks#email_confirmation', as: :email_confirmation
    post 'send_email_confirmation_message', to: 'oauth_callbacks#send_email_confirmation_message',
                                            as: :send_email_confirmation_message
  end

  concern :votable do
    member do
      patch :vote_for
      patch :vote_against
      delete :revote
    end
  end

  resources :questions, concerns: :votable do
    resources :answers, shallow: true, concerns: :votable do
      patch :choose_best, on: :member
    end
  end

  post 'questions/:commentable_id/comments', to: 'comments#create', defaults: { commentable: 'questions' },
                                             as: :question_comments
  post 'answers/:commentable_id/comments', to: 'comments#create', defaults: { commentable: 'answers' },
                                           as: :answer_comments

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
