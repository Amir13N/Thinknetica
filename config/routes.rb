# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
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

  resources :users, only: [:index]

  resources :searches, only: [:index]
  scope 'searches' do
    post '', to: 'searches#all', as: :searches_all
    post 'users', to: 'searches#users', as: :searches_users
    scope 'questions' do
      post '', to: 'searches#questions', as: :searches_questions
      post ':question_id/answers', to: 'searches#answers', as: :searches_answers
      post ':commentable_id/comments', to: 'searches#comments', as: :searches_question_comments,
                                       defaults: { commentable: 'question' }
    end
    post 'answers/:commentable_id/comments', to: 'searches#comments', as: :searches_answer_comments,
                                             defaults: { commentable: 'answer' }
  end

  resources :subscriptions, only: %i[create], path: 'subscriptions/:question_id'
  delete 'subscriptions/:question_id', to: 'subscriptions#destroy', as: :subscription

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

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, only: %i[index show update destroy create] do
        resources :answers, shallow: true, only: %i[show update destroy create]
      end
    end
  end

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
