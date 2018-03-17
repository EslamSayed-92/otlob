Rails.application.routes.draw do
  resources :friendships
  resources :items
  resources :orders 
  resources :groups
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  resources :users
  root 'welcome#index'
  get '/ordersList', to: 'orders#ordersList'
  mount ActionCable.server => '/cable'

  # AJAX Routes
  post '/friendships/find', to: 'friendships#find'
  post '/groups/addToGroup', to: 'groups#addToGroup'
  post '/groups/removeFromGroup', to: 'groups#removeFromGroup'
  post '/invitation', to:'invitations#invit'
  post '/addfriend', to: 'invitations#create'



  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
