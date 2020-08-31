Rails.application.routes.draw do
  namespace :v1, format: 'json' do
    resources :apidocs, only: [:index]

    # Address API
    resources :addresses, param: :code, only: [:index] do
      get :search, on: :collection
      get :geocoding, on: :collection
      get :shapes, on: :collection
    end

    # Analytics API
    namespace :analytics do
      resource :addresses, only: [] do
        post :contains, on: :collection
      end
    end

    # Statistics API
    namespace :statistics do
      resource :addresses, only: [] do
        get :populations, on: :collection
      end
    end
  end
end
