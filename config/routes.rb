Rails.application.routes.draw do

  scope Regulate.route_namespace, :module => :regulate, :as => :regulate do
    resources :pages, :only => [ :show ]
    scope "admin", :module => :admin, :as => :admin do
      resources :pages
    end
  end

end
