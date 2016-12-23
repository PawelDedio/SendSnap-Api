Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post 'session/create' => 'sessions#create'
  delete 'session/destroy' => 'sessions#destroy'

  put 'users/block/:id' => 'users#block'
  resources :users

  get 'friend_invitations/from_me' => 'friend_invitations#from_me'
  get 'friend_invitations/to_me' => 'friend_invitations#to_me'
  resources :friend_invitations
end
