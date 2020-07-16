# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  resources :questions do
    resources :answers, shallow: true do
      patch :choose_best, on: :member
      patch 'files/:file_id/delete_file', to: 'answers#delete_file', on: :member, as: :delete_file
    end

    patch 'files/:file_id/delete_file', to: 'questions#delete_file', on: :member, as: :delete_file
  end

  root to: 'questions#index'
end
