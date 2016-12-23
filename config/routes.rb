Rails.application.routes.draw do
  resources :friend_invitations
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users
  put 'users/block/:id' => 'users#block'

  post 'session/create' => 'sessions#create'
  delete 'session/destroy' => 'sessions#destroy'
end
