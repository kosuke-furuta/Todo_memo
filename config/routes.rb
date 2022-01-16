Rails.application.routes.draw do
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
  resources :tasks do
    resource :favorites, only: [:create, :destroy]
  end
end
