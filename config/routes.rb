Rails.application.routes.draw do
  get 'bookmarks/create'
  get 'bookmarks/destroy'
  root 'static_pages#home'
  get '/about', to: 'static_pages#about'
  get '/profile', to: 'static_pages#profile'
  get '/contact', to: 'static_pages#contact'
  get '/news', to: 'static_pages#news'
  get '/signup', to: 'users#new'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :tasks do
    resource :bookmarks, only: [:create, :destroy]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
