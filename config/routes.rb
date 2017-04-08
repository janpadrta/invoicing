# frozen_string_literal: true

Rails.application.routes.draw do
  get 'invoicing/home'
  get 'invoicing/clear'

  post 'invoicing/upload'

  root to: 'invoicing#home'

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :invoices, only: [:index]
      namespace :summary do
        resources :months, only: [:index]
        resources :categories, only: [:index]
      end
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
