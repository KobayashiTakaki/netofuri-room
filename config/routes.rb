Rails.application.routes.draw do
  root 'base#index'
  resources :rooms, only: [:show]
  resources :viewings, only: [:new, :create]
end
