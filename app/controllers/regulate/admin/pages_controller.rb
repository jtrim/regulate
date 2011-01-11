module Regulate

  # Our admin namespace to contain any related controllers
  module Admin

    # Standard CRUD Controller
    class PagesController < ActionController::Base
      # Check that a user is authenticated
      before_filter :is_authorized?
      # Load in our page object based on the ID
      before_filter :load_page, :only => [:edit,:update,:destroy]

      # POST route to create a new page
      def create
        if Regulate::Page.create!(params[:page])
          flash[:notice] = "Page created!"
          redirect_to regulate_admin_regulate_pages_path
        else
          render :action => :new
        end
      end

      # GET skeleton method to get to an edit page
      def edit; end

      # PUT method to persist changes to a Page object
      def update
        params[:page].delete(:view) if !@authorized_user.is_admin?
        if @page.update_attributes(params[:page])
          flash[:notice] = "Successfully updated #{params[:page][:title]}"
          redirect_to regulate_admin_regulate_pages_path
        else
          render :action => :edit
        end
      end

      # GET method to show new Page form
      def new
        @page = Regulate::Page.new
      end

      # DELETE method to destroy a page
      def destroy
        @page.destroy
        flash[:notice] = "Page deleted."
        redirect_to regulate_admin_regulate_pages_path
      end

      # GET skeleton method to show a list of pages
      def index
        @pages = Regulate::Page.find_all
      end

      # GET method to view a page
      # Render the edit action
      def show
        render :action => :edit
      end

      private

      def is_authorized?
        @authorized_user = AbstractAuth.invoke :authorized_user
        @is_admin = AbstractAuth.invoke :is_admin
        @is_editor = AbstractAuth.invoke :is_editor
      end

      # Grab a page resource based on the ID passed to the URI
      def load_page
        @page = Regulate::Page.find(params[:id])
      end

    end # class PagesController

  end # module Admin

end # module Regulate

