Rails.application.routes.draw do
  resources :brands, only: [ :index, :show, :create ] do
    member do
      get "models", to: "models_get"
      post "models", to: "models_post"
    end
  end
  resources :models, only: [ :index, :update ]
  post "reset", to: "database#reset"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
