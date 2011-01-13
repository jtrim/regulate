class ApplicationController < ActionController::Base

  def index
    render :text => "hello"
  end

  protect_from_forgery

  def current_user
    User.new
  end

end
