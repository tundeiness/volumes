Rails.application.routes.draw do
  # get 'users/update'
  devise_for :users
  # devise_for :users, controllers: { registrations: 'user/registrations' }
  root 'home#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  resources :users, only: [:index, :edit, :update]
  get '/admin_dashboard', to: 'dashboard#admin', as: 'admin_dashboard'
  get '/therapist_dashboard', to: 'dashboard#therapist', as: 'therapist_dashboard'
  get '/client_dashboard', to: 'dashboard#client', as: 'client_dashboard'

  # namespace :dashboard do
  #   get 'admin', to: 'dashboard#admin', as: 'admin'
  #   get 'therapist', to: 'dashboard#therapist', as: 'therapist'
  #   get 'client', to: 'dashboard#client', as: 'client'
  # end
end
