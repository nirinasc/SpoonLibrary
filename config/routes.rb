Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  # devise_for :users, ActiveAdmin::Devise.config
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
