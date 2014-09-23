Rails.application.routes.draw do
  root 'sites#index'

  post "/login" => "sessions#create"

  delete '/logout' => 'sessions#destroy'
  get '/logout' => 'sessions#destroy'

  resources :requests, except: [:new, :edit]

  resources :sites
  resources :passwords
  resources :users

end
