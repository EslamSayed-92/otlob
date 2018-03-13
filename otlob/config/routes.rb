Rails.application.routes.draw do
  resources :friendships
  resources :items
  resources :orders
  resources :groups
  devise_for :users
  resources :users
  root 'welcome#index'


  # AJAX Routes
  post '/users/find', to: 'users#find'
  post '/friendships/find', to: 'friendships#find'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
