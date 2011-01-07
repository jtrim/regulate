Rails.application.routes.draw do

  # Load our engine's routes in to the host app:
  #   - Load our route namespace directly from the engine gem
  #   - Use the Regulate module
  #   - Make sure our route names are namespaced under regulate_
  scope Regulate.route_namespace, :module => :regulate, :as => :regulate do

    # Only allow the show action publicly
    resources :pages, :only => [ :show ]

    # In the admin, allow all actions
    # Ensure that we're setting our scoping options properly:
    #   - namespaced to "admin"
    #   - under the Admin module
    #   - the route names namespaced under admin_
    scope "admin", :module => :admin, :as => :admin do
      resources :pages
    end
  end

end
