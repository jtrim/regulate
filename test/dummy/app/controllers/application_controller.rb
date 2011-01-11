class ApplicationController < ActionController::Base

  protect_from_forgery

  def self.current_user
    return User.new
  end

end
