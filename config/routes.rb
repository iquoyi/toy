Rails.application.routes.draw do
  resources :employees do
    resources :contracts
  end
  root 'static#index'
end
