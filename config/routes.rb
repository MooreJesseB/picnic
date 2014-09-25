Rails.application.routes.draw do
  root 'sites#index'

  post "/login" => "sessions#create"

  delete '/logout' => 'sessions#destroy'
  get '/logout' => 'sessions#destroy'

  resources :requests

  resources :request_templates
  resources :site_templates
  resources :user_tempaltes

  resources :sites
  resources :passwords
  resources :users

end
