Phototaggr::Application.routes.draw do
  root :to => "photos#index"
  
  resource :session, :only => [:new, :create, :destroy]
  
  resources :users, :only => [:index, :new, :create, :show] do
    resource :friendship, :only => [:create, :destroy]
    get '/friendships', to: 'friendships#show'
    get '/followers', to: 'friendships#followers'
    resources :photos, :only => [:index]
  end

  resources :photos, :only => [:index, :create, :update, :destroy, :show] do
    resources :tags, :only => [:create, :destroy, :index]
  end
  
  
end
