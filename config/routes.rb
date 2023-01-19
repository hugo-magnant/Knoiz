Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"

  get '/auth/spotify/callback', to: 'users#spotify'
  get '/create_playlist', to: 'home#create_playlist'

  post 'create_playlist', to: 'home#create_playlist'


end
