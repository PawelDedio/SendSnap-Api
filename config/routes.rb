Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users

  post 'users/sign_in' => 'sessions#create'
  delete 'users/sign_out' => 'sessions#destroy'
end
