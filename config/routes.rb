Rails.application.routes.draw do
  resources :contracts
  resources :employees
  root 'static#index'
end
