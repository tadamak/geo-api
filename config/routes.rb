Rails.application.routes.draw do
  namespace :v1 do
    resources :addresses, only: [:show], defaults: { format: :json } do
      get :search, on: :collection
    end

    resources :address_shapes, only: [:show], defaults: { format: :json } do
      get :search, on: :collection
    end
  end
end
