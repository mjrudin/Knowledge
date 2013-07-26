Contacts::Application.routes.draw do
  resources :users, :except => [:index, :new, :edit] do
    resources :contacts, :only => [:index, :show, :create, :update] do
      get "favorite" => "favorites#create"
      get "unfavorite" => "favorites#destroy"
    end
    resources :favorites, :only => [:index]
  end
  resource :session, only: [:create, :destroy]
end
