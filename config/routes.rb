Rails.application.routes.draw do
  root to: "subs#index"
  
  resources :users
  resource :session, only: [:new, :create, :destroy]
  resources :subs, except: [:destroy] do
    resources :posts, only: [:new, :create]
  end
  resources :posts, except: [:index, :destroy] do
    resources :comments, only: [:show, :create, :new, :update, :edit]
  end
  
end
# ††††††††††††††††††††††††††††††††††††††††††††††††††††††††††††††††††††††††††††††††††††††††††††††††††††††††††††††††††††††††††††††††††††