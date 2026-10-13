# frozen_string_literal: true

Rails.application.routes.draw do
  get '/auth/:provider/callback', to: 'sessions#create', as: :auth_callback
  post '/logout', to: 'sessions#destroy'

  direct :entra_login do
    '/auth/entra_id'
  end
end
