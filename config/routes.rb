# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :users,
             skip: :registrations,
             path: 'auth',
             path_names: { sign_in: 'login', sign_out: 'logout', password: 'secret' },
             controllers: { sessions: 'auth/sessions', passwords: 'auth/passwords' }

  devise_scope :user do
    resource :registration,
             only: %i[new create edit update],
             path: 'auth/register',
             path_names: { new: '', edit: 'edit' },
             controller: 'auth/registrations',
             as: :user_registration do
      get :cancel
    end
  end
  # devise_for :users, ActiveAdmin::Devise.config
  get '/notifications/signup-success', to: 'auth/notifications#success_signup', as: 'notifications_success_signup'
  get '/store(/library/:library)', to: 'store#index', as: 'store_index'
  get '/store/:id', to: 'store#show', as: 'store_show'
  # book resource routes
  post '/books/:id/loan', to: 'books#loan', as: 'book_loan_create'
  post '/books/:id/comment', to: 'books#comments_create', as: 'book_comments_create'
  get '/books/:id/availability', to: 'books#availability', as: 'book_availability'
  # log resource routes
  get '/logs/loans', to: 'logs#loans', as: 'loans'
  get '/logs/returns', to: 'logs#returns', as: 'returns'
  post '/logs/:loan/returns', to: 'logs#returning', as: 'return_create'

  # rest api endpoints
  namespace :api, defaults: { format: :json } do
    scope module: :v1, constraints: ApiVersion.new('v1', true) do
      post '/auth/login', to: 'auth#login', as: 'auth_login'
      get '/users/me', to: 'users#me', as: 'user_me'
      resources :libraries, only: :index
      resources :categories, only: :index
      resources :books, only: %i[index show] do
        resources :comments, only: %i[index create]
      end
      # loans and book returns
      get '/logs/loans', to: 'logs#loans', as: 'loans'
      get '/logs/returns', to: 'logs#returns', as: 'returns'
      post '/logs/:loan_id/returns', to: 'logs#create_return', as: 'return_create'
      post '/logs/:book_id/loans', to: 'logs#create_loan', as: 'loan_create'
    end
  end

  # swagger ui routes
  mount SwaggerUiEngine::Engine, at: '/docs'

  root to: 'home#index'
end
