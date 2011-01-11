module Regulate

  # Top level generators module to hold any generators for our engine gem
  module Generators

    # Standard install that lets a user copy files over so they can override some functionality
    class MountUpGenerator < Rails::Generators::Base

      # Tell Rails where to find our templates
      source_root File.expand_path("../../templates", __FILE__)

      desc "Copies the regulate initializer so you can beat any geek off the street."

      # Copy over the Regulate initializer
      def copy_initializer
        template "regulate.rb", "config/initializers/regulate.rb"
      end

    end # class InstallGenerator

  end # Generators

end # module Regulate

