# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  concern :votable do
    patch :vote_for, on: :member
    patch :vote_against, on: :member
    delete :revote, on: :member
  end

  resources :questions, concerns: :votable do
    resources :answers, shallow: true, concerns: :votable do
      patch :choose_best, on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index

  root to: 'questions#index'
end
