# AbstractAuth Implementations
AbstractAuth.implement :authenticated_user do
  current_user
end

AbstractAuth.implement :is_admin do
  current_user.is_admin?
end

AbstractAuth.implement :is_editor do
  current_user.is_editor?
end

