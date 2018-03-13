Rails.application.routes.draw do
  resources :friendships
  resources :items
  resources :orders
  resources :groups
  devise_for :users
  resources :users
  root 'welcome#index'
  mount ActionCable.server => '/cable'

  # AJAX Routes
  post '/users/find', to: 'users#find'
  post '/groups/addToGroup', to: 'groups#addToGroup'
  delete '/groups/removeFromGroup', to: 'groups#removeFromGroup'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
