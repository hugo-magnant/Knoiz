Rails.application.routes.draw do

  get 'subscriptions/new'
  get 'subscriptions/create'
  get 'subscriptions/update'
  get 'subscriptions/cancel'

  devise_for :users

  root "home#index"
  get '/home/faq', to: 'home#faq', :as => :faq
  get '/home/pricing', to: 'home#pricing', :as => :pricing

  get '/auth/spotify/callback', to: 'users#spotify', :as => :spotify

  get '/create_playlist', to: 'home#create_playlist'
  post 'create_playlist', to: 'home#create_playlist'

  get 'pricing', to: 'pricing#index'

  get '/users/charge', to: 'users#charge'
  get '/users/info', to: 'users#info'
  get '/users/reset_credits_unsubscribe', to: 'users#reset_credits_unsubscribe'
  get '/users/reset_credits_subscribe', to: 'users#reset_credits_subscribe'

  post '/checkout_session/create', to: 'checkout_session#create'

end
