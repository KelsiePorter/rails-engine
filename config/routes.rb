Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do 
      resources :items do
        resources :merchant, only: [:index], controller: 'items/merchants'
      end
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], controller: 'merchants/items'
      end
    end
  end
end
