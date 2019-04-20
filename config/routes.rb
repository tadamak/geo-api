Rails.application.routes.draw do
  namespace :v1, format: 'json' do
    # Address API
    resources :addresses, param: :code, only: [:show] do
      get :search, on: :collection
    end

    namespace :addresses do
      resources :shapes, param: :code, only: [:show]
    end

    # Analytics API
    namespace :analytics do
      resource :addresses, only: [] do
        get :contains, on: :collection
        post :contains, on: :collection
      end
    end
  end
end
