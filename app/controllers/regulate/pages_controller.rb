module Regulate

  class PagesController < ActionController::Base

    def show
      @page = Regulate::Page.find(params[:id])
    end

  end

end
