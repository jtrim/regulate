module Regulate

  module Helpers

    module ControllerHelpers

      private

      # Check that a user is authenticated
      def is_authenticated?
        @authenticated_user = instance_eval &AbstractAuth.invoke(:authenticated_user)
        @is_admin = instance_eval &AbstractAuth.invoke(:is_admin)
        # Uncomment the following line to test out admin interface
        #@is_admin = true
        @is_editor = instance_eval &AbstractAuth.invoke(:is_editor)
      end

      # Check that the user is at least an editor
      def is_editor?
        redirect_to root_path if !@is_editor
      end

      # Check that the user is an admin
      def is_admin?
        redirect_to regulate_admin_regulate_pages_path if !@is_admin
      end

      # Grab a page resource based on the ID passed to the URI
      # Load in our page object based on the ID
      def load_page
        @page = Regulate::Page.find(params[:id])
      end

      # Check whether a page is published
      def is_published?
        if !@is_admin || !@is_editor
          redirect_to root_path if !@page.published
        end
      end

    end

  end

end

