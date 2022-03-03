Rails.application.routes.draw do
  resources :employees do
    resources :contracts, except: :index
  end
  root 'static#index'
end
