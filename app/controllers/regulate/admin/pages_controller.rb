module Regulate

  module Admin

    # Standard CRUD Controller
    class PagesController < ActionController::Base
      before_filter :load_page, :only => [:edit,:update,:destroy]

      def create
        @page = Regulate::Page.new
        @page.attributes = params[:page]
        if @page.save
          flash[:notice] = "Page created!"
          redirect_to regulate_admin_pages_path
        else
          render :action => :new
        end
      end

      def edit; end

      def update
        if @page.update_attributes(params[:page])
          flash[:notice] = "Successfully updated #{params[:page][:title]}"
          redirect_to regulate_admin_pages_path
        else
          render :action => :edit
        end
      end

      def new
        @page = Regulate::Page.new
      end

      def destroy
        @page.destroy
        flash[:notice] = "Page deleted."
        redirect_to regulate_admin_pages_path
      end

      def index; end

      def show
        redirect_to :action => :edit
      end

      private

      def load_page
        @page = Regulate::Page.find(params[:id])
      end

    end # class PagesController

  end # module Admin

end # module Regulate

