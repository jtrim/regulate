module Regulate

  class PagesController < ::ApplicationController
    include Regulate::Helpers::ControllerHelpers
    before_filter :load_page
    before_filter :is_authenticated?
    before_filter :is_published?

    def show; end

  end # class PagesController

end # class Regulate
