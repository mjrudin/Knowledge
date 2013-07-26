Cats99::Application.routes.draw do
  resources :cats do
    resources :cat_rental_requests
  end

  resources :users, only: [:new, :create]
  resource :session, only: [:new, :create, :destroy]

  root to: "cats#index"
end
