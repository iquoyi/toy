Rails.application.routes.draw do
  resources :employees
  root 'static#index'
end
