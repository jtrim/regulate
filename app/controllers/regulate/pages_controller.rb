module Regulate

  # @todo Build out XHR-only methods for frontend inline editing
  class PagesController < ActionController::Base

    # Show function for front-end
    def show
      @page = Regulate::Page.find(params[:id])
    end

  end # class PagesController

end # class Regulate
