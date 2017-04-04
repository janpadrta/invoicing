# frozen_string_literal: true

Rails.application.routes.draw do
  get 'invoicing/home'
  get 'invoicing/clear'

  post 'invoicing/upload'

  root to: 'invoicing#home'

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      get 'invoices', to: 'invoices#collection'
      get 'summary/months', to: 'invoices#summary_by_months'
      get 'summary/categories', to: 'invoices#summary_by_categories'
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
