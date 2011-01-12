# Regulate stuff

# AbstractAuth Implementations
AbstractAuth.implement :authorized_user do
  ::ApplicationController.instance_eval "current_user"
end

AbstractAuth.implement :is_admin do
  ::ApplicationController.instance_eval("current_user").is_admin?
end

AbstractAuth.implement :is_editor do
  ::ApplicationController.instance_eval("current_user").is_editor?
end
