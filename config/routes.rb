Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :users, 
             path: 'auth', 
             path_names: { sign_in: 'login', sign_out: 'logout', password: 'secret',registration: 'register', 'sign_up': ''},
             controllers: { sessions: 'auth/sessions', passwords: 'auth/passwords', registrations: 'auth/registrations' }
  # devise_for :users, ActiveAdmin::Devise.config
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/notifications/signup-success', to: 'auth/notifications#success_signup', as: 'notifications_success_signup'
  get '/store', to: 'store#index', as: 'store_index'

  root to: 'home#index'
  
end
