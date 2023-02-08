Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do 
      resources :items
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], controller: 'merchants/items'
      end
    end
  end
end
