# config/routes.rb
Rails.application.routes.draw do
  # Setzt die Startseite auf die Dashboard-Ansicht des Users
  root "users#dashboard"
  
  resources :sessions, only: [:new, :create, :destroy] do
    post :attack, on: :collection
  end
  get 'logout', to: 'sessions#destroy'
  
  resources :users
  resources :categories
  resources :products
  resources :subscriptions
end