Rails.application.routes.draw do
  namespace :v1, format: 'json' do
    resources :apidocs, only: [:index]

    # Address API
    resources :addresses, param: :code, only: [:index, :show] do
      get :search, on: :collection
    end

    namespace :addresses do
      resources :shapes, param: :code, only: [:show]
    end

    # Analyses API
    namespace :analyses do
      resource :addresses, only: [] do
        get :contains, on: :collection
        post :contains, on: :collection
      end
    end
  end
end
