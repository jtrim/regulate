# Regulate stuff

# AbstractAuth Implementations
AbstractAuth.implement :authorized_user do
  ::ApplicationController.send('current_user')
end

AbstractAuth.implement :is_admin do
  ::ApplicationController.send('current_user').is_admin?
end

AbstractAuth.implement :is_editor do
  ::ApplicationController.send('current_user').is_editor?
end
