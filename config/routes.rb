require 'sidekiq/web'

if Rails.env.production? or Rails.env.development?
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV['SIDEKIQ_USERNAME'] && password == ENV['SIDEKIQ_PASSWORD']
  end
  Sidekiq::Web.use ActionDispatch::Cookies
  Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: "_interslice_session"
end

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  mount Sidekiq::Web => '/sidekiq'
  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api do
    namespace :v1 do
      post "/login", to: "auth#create"
      get "/oauth/authorize", to: "auth#oauth_authorize"
      get "/github/authorize", to: "github#index"
      get "/github/repositories", to: "github#show"
      resources :users, param: :username
      resources :projects do
        member do
          get :statistics
        end
      end
      resources :boards
      resources :tasks do
        member do
          put :update_states
        end
      end
      resources :repositories, only: [:index]
    end
  end
end
