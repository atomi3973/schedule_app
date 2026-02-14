Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  root "home#index"
  resources :schedules
  post "/line/callback", to: "line_bot#callback"
end
