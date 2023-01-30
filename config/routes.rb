Rails.application.routes.draw do

  resources :users, only: [:create]

  root "home#index"
  get '/home/faq', to: 'home#faq', :as => :faq
  get '/home/pricing', to: 'home#pricing', :as => :pricing

  post '/create_playlist', to: 'home#create_playlist'


  delete '/logout', to: 'sessions#destroy', as: 'logout'

  get "/auth/spotify/callback", to: "sessions#create"
  get "/auth/spotify", to: "sessions#create"


  post '/checkout_session/create', to: 'checkout_session#create'

  get 'subscriptions/new'
  get 'subscriptions/create'
  get 'subscriptions/update'
  get 'subscriptions/cancel'

  get '/users/charge', to: 'users#charge'
  get '/users/info', to: 'users#info'

end
