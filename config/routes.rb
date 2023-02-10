Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do 
      get '/items/find', to: 'items/search#show'
      get '/merchants/find_all', to: "merchants/search#index"

      resources :items do
        resource :merchant, only: [:show], controller: 'items/merchant'
      end
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], controller: 'merchants/items'
      end
    end
  end
end
