Rails.application.routes.draw do
  get 'password_resets/new'

  resources :friendships
  resources :items
  resources :orders
  resources :groups
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  resources :users
  resources :password_resets
  root 'welcome#index'

  get '/ordersList', to: 'orders#ordersList'
  get '/orderDetails', to: 'orders#orderDetails'
  get '/finish', to:'orders#finish'
  get '/cancel', to:'orders#cancel'
  mount ActionCable.server => '/cable'

  # Reset Password Routes
  get  '/passwords/new', to: 'passwords#new'
  post '/passwords/forgot', to: 'passwords#forgot'
  post '/passwords/reset', to: 'passwords#reset'

  # AJAX Routes
  post '/friendships/find', to: 'friendships#find'
  post '/groups/addToGroup', to: 'groups#addToGroup'
  post '/groups/removeFromGroup', to: 'groups#removeFromGroup'
  post '/invitation', to:'invitations#invit'
  post '/addfriend', to: 'invitations#create'


  delete '/invitations/:id', to:'invitations#destroy'
  post '/orders/invite', to: 'orders#invite'
  post '/orders/uninvite', to: 'orders#uninvite'





  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
