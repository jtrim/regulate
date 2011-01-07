module Regulate

  # Top level generators module to hold any generators for our engine gem
  module Generators

    # Standard install that lets a user copy files over so they can override some functionality
    class InstallGenerator < Rails::Generators::Base

      # Tell Rails where to find our templates
      source_root File.expand_path("../../templates", __FILE__)

      desc "Copies files to your application that regulate needs."

      # Copy over our CSS
      def copy_css
        template "regulate.css", "public/stylesheets/regulate.css"
      end

      # Copy over our JS
      def copy_js
        template "regulate.js", "public/javascripts/regulate.js"
      end

      # Copy over the repo config YAML file
      def copy_yml
        template "regulate.yml", "config/regulate.yml"
      end

      # Copy over the Regulate initializer
      def copy_initializer
        template "regulate.rb", "config/initializers/regulate.rb"
      end

    end # class InstallGenerator

  end # Generators

end # module Regulate

