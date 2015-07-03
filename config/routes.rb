InsanityPleaStudios::Application.routes.draw do
  # resources :projects
#
#   resources :users

  resource :session, only: [:create, :destroy, :new]
  # resources :users do
#     get :activate, on: :collection
#     get :password_reset, on: :collection
#     put :password_update, on: :collection
#     put :sort, on: :collection
#     resources :pictures
#   end
  
  
  resources :pictures
  resources :contact_mes, only: [:new, :create]
  
  
  get 'session', to: redirect('/')
  # get 'auth/:provider/callback', to: 'sessions#update_facebook_auth'
  # get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'
  
  root to: "pages#home"
end
