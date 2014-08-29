Rails.application.routes.draw do
  root to: "subs#index"
  
  resources :users
  resource :session, only: [:new, :create, :destroy]
  resources :subs, except: [:destroy] do
    resources :posts, only: [:new, :create]
  end
  resources :posts, except: [:index, :destroy]
  
end
