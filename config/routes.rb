Rails.application.routes.draw do
  resources :users, only: [:create]

  root "home#index"
  post "/create_playlist", to: "home#create_playlist"

  get "/pricing/index", to: "pricing#index", :as => :pricing

  get "/stats/index", to: "stats#index", :as => :stats
  get "/stats/tops", to: "stats#tops", :as => :tops
  get "/stats/recently", to: "stats#recently", :as => :recently
  get "/stats/top_global", to: "stats#top_global", :as => :top_global

  get "/auth/spotify/callback", to: "sessions#create"
  get "/auth/spotify", to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: "logout"

  post "/checkout_session/create", to: "checkout_session#create"

  get "subscriptions/new"
  get "subscriptions/create"
  get "subscriptions/resume"
  get "subscriptions/cancel", to: "subscriptions#cancel", :as => :cancel

  get "/users/charge", to: "users#charge"
  get "/users/info", to: "users#info", :as => :info

  require "sidekiq/web"
  mount Sidekiq::Web => "/sidekiq"
end
