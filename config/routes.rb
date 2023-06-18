Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :books, only: [:index, :show]
  resources :authors, only: [:index, :show]

  namespace :admin do
    resources :books, only: [:new, :create, :edit, :update, :destroy]
    resources :authors, only: [:new, :create, :edit, :update, :destroy]
    resources :dashboard, only: [:index] do
      collection do
        post :upload
      end
    end
  end
end
