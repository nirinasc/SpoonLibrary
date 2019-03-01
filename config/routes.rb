Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :users,
             skip: :registrations,
             path: 'auth', 
             path_names: { sign_in: 'login', sign_out: 'logout', password: 'secret'},
             controllers: { sessions: 'auth/sessions', passwords: 'auth/passwords' }
  
  devise_scope :user do
    resource :registration,
      only: [:new, :create, :edit, :update],
      path: 'auth/register',
      path_names: { new: '', edit: 'edit' },
      controller: 'auth/registrations',
      as: :user_registration do
        get :cancel
    end
  end           
  # devise_for :users, ActiveAdmin::Devise.config
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/notifications/signup-success', to: 'auth/notifications#success_signup', as: 'notifications_success_signup'
  get '/store(/library/:library)', to: 'store#index', as: 'store_index'
  get '/store/:id', to: 'store#show', as: 'store_show'

  root to: 'home#index'
  
end
