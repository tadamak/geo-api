Rails.application.routes.draw do
  namespace :v1, format: 'json' do
    resources :addresses, param: :code, only: [:show] do
      get :search, on: :collection
    end

    resources :geo_addresses, param: :code, only: [:show]
  end
end
