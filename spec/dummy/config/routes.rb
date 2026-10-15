# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index'

  resources :users, only: %i[index show]
end
