Rails.application.routes.draw do
  namespace :v1, format: 'json' do
    resources :apidocs, only: [:index]

    # Address API
    resources :addresses, param: :code, only: [:index] do
      get :search, on: :collection
      get :shapes, on: :collection
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
