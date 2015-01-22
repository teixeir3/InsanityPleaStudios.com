WeightLoss::Application.routes.draw do
  resource :session, only: [:create, :destroy, :new]
  resources :users do
    get :activate, on: :collection
    get :password_reset, on: :collection
    put :password_update, on: :collection
    put :sort, on: :collection
    resources :pictures
  end
  
  resources :pictures
  
  
  
  get 'session', to: redirect('/')
  get 'auth/:provider/callback', to: 'sessions#update_facebook_auth'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'
  
  root to: "sessions#new"
end
