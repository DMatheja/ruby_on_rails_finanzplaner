# config/routes.rb
Rails.application.routes.draw do
  # Setzt die Startseite auf die Dashboard-Ansicht des Users
  root "users#dashboard"

  resources :sessions, only: [ :new, :create, :destroy ] do
    post :attack, on: :collection
  end
  get "logout", to: "sessions#destroy"

  namespace :admin do
  resource :time_travel, only: [ :show, :update, :destroy ]
  end


  resources :users
  resources :categories do
    member do
      patch :mark_all_purchased
      patch :mark_product_purchased
      patch :remove_product
      patch :assign_product
    end
  end
  resources :products do
    collection do
      get :purchased
    end
    member do
      patch :rebuy
      patch :mark_purchased
      post :readd
    end
  end
  resources :subscriptions
end
