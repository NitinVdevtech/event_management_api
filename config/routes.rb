Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'signup', to: 'authentications#signup'
      post 'login', to: 'authentications#login'
      resources :events, only: [:index, :show, :create, :update, :destroy]
    end
  end
end
