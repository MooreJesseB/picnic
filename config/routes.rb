Rails.application.routes.draw do
  root 'sites#index'

  resources :sites
  resources :passwords
end
