Rails.application.routes.draw do
  root 'base#index'
  resources :rooms, only: [:index, :show]
  resources :videos, only: [] do
    resources :comments, only: [:index, :create]
  end
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
