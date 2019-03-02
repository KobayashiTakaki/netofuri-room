Rails.application.routes.draw do
  root 'base#index'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  post 'join', to: 'joinings#create'
  delete 'leave', to: 'joinings#destroy'
  resources :rooms, only: [:index, :show]
  resources :videos, only: [] do
    resources :comments, only: [:index, :create]
  end
  resources :users, only: [:new, :create, :edit, :update]
  resources :comments, only: [:index]
  namespace :admin do
    resources :video_sets do
      resources :videos, only: [:index, :new, :create]
      collection {post :import}
    end
    resources :videos do
      collection {post :import}
    end
  end
end
