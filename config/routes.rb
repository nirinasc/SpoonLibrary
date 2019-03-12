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
  get '/store/loans', to: 'store#loans', as: 'store_loans'
  get '/store/returns', to: 'store#returns', as: 'store_returns'
  post '/store/:loan/returns', to: 'store#returning', as: 'store_return'
  post '/store/:id/loan', to: 'store#loan', as: 'store_loan'
  get '/store/:id', to: 'store#show', as: 'store_show'
  post '/store/:id/comment', to: 'store#comments_create', as: 'store_comments_create'

  #rest api end points
  namespace :api, :defaults => {:format => :json} do
    scope module: :v1, constraints: ApiVersion.new('v1', true) do
      post '/auth/login', to: 'auth#login', as: 'auth_login'
      get '/users/me', to: 'users#me', as: 'user_me'
      resources :libraries,  only: :index
      resources :categories,  only: :index 
      resources :books,  only: [:index,:show] do
        resources :comments, only: [:index, :create]
      end
      #loans and book returns
      get '/logs/loans', to: 'logs#loans', as: 'loans'
      get '/logs/returns', to: 'logs#returns', as: 'returns'
      post '/logs/:loan_id/returns', to: 'logs#create_return', as: 'return_create'
      post '/logs/:book_id/loans', to: 'logs#create_loan', as: 'loan_create'
    end
  end

  mount SwaggerUiEngine::Engine, at: "/"
  
  root to: 'home#index'
  
end
