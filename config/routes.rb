Rails.application.routes.draw do
  namespace :v1 do
    resources :addresses, only: [:show], defaults: { format: :json } do
      collection do
        get :search
      end
    end

    resources :address_shapes, only: [:show], defaults: { format: :json } do
      collection do
        get :search
      end
    end
  end
end
