Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/', to: 'welcome#index'

  get '/merchants/new', to: 'merchants#new'
  post '/merchants', to: 'merchants#create'
  get '/merchants', to: 'merchants#index'
  get '/merchants/:id', to: 'merchants#show'
  get '/merchants/:id/edit', to: 'merchants#edit'
  patch '/merchants/:id', to: 'merchants#update'
  delete '/merchants/:id', to: 'merchants#destroy', as: 'merchant'
  get '/merchants/:merchant_id/items', to: 'items#index'
  # resources :merchants do
  #   resources :items, only: [:index]
  # end

  get '/items', to: 'items#index', as: 'items'
  get '/items/:id', to: 'items#show', as: 'item'
  get '/items/:item_id/reviews', to: 'reviews#new', as: 'new_item_review'
  post '/items/:item_id/reviews', to: 'reviews#create', as: 'item_reviews'
  # resources :items, only: [:index, :show] do
  #   resources :reviews, only: [:new, :create]
  # end

  get '/reviews/:id/edit', to: 'reviews#edit', as: 'edit_review'
  patch '/reviews/:id', to: 'reviews#update'
  delete '/reviews/:id', to: 'reviews#destroy', as: 'review'
  # resources :reviews, only: [:edit, :update, :destroy]

  resources :cart, only: [:index, :create, :update, :destroy]
  # get '/cart', to: 'cart#show'
  # post '/cart/:item_id', to: 'cart#add_item'
  # delete '/cart', to: 'cart#empty'
  # patch '/cart/:change/:item_id', to: 'cart#update_quantity'
  # delete '/cart/:item_id', to: 'cart#remove_item'

  resources :users, only: [:new, :create, :index, :show, :update]
  # get '/registration', to: 'users#new', as: :registration
  # patch '/user/:id', to: 'users#update'

  # these should ultimately nest under users, i think.
  get '/profile', to: 'users#show'
  get '/profile/edit', to: 'users#edit'
  get '/profile/edit_password', to: 'users#edit_password'
  post '/orders', to: 'user/orders#create'
  get '/profile/orders', to: 'user/orders#index'
  get '/profile/orders/:id', to: 'user/orders#show'
  delete '/profile/orders/:id', to: 'user/orders#cancel'

  resources :sessions, only: [:new, :create, :destroy]
  # get '/login', to: 'sessions#new'
  # post '/login', to: 'sessions#login'
  # get '/logout', to: 'sessions#destroy'

  namespace :merchant do
    get '/', to: 'dashboard#index', as: :dashboard
    resources :discounts
    resources :orders, only: :show
    resources :items, only: [:index, :new, :create, :edit, :update, :destroy]
    put '/items/:id/change_status', to: 'items#change_status'
    get '/orders/:id/fulfill/:order_item_id', to: 'orders#fulfill'
  end

  namespace :admin do
    get '/', to: 'dashboard#index', as: :dashboard
    resources :merchants, only: [:show, :update]
    resources :users, only: [:index, :show]
    patch '/orders/:id/ship', to: 'orders#ship'
  end
end
