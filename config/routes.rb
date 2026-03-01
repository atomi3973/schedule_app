Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  root "home#index"
  get 'terms', to: 'home#terms'
  get 'privacy', to: 'home#privacy'
  resources :schedules
  post "/line/callback", to: "line_bot#callback"
  post '/scheduler/execute_notifications', to: 'scheduler#execute'
end
