Rails.application.routes.draw do
  root 'teddies#index'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  resources :teddies, only: %i[index show]
  resources :orders, only: %i[show create index] do
    resource :payment, only: [:show]
  end
  post 'wx_notify', to: 'payments#wx_notify'
end
