module Regulate

  module Generators

    # Class lifted from Devise.  Thanks josevalim!
    class StrapGenerator < Rails::Generators::Base

      # Tell Rails where our view files are
      source_root File.expand_path("../../../..", __FILE__)
      desc "Copies all Regulate views, js, and yaml files to your application in app/views/regulate/."
      class_option :template_engine, :type => :string, :aliases => "-t",
                                     :desc => "Template engine for the views. Available options are 'erb' and 'haml'."

      # Copy over our view files
      def copy_views
        case options[:template_engine].to_s
        when "haml"
          verify_haml_existence
          verify_haml_version
          create_and_copy_haml_views
        else
          directory "app/views/regulate", "app/views/regulate"
        end
      end

      # Copy over our JS
      def copy_js
        template "public/javascripts/regulate_admin.js", "public/javascripts/regulate_admin.js"
      end

      # Copy over the repo config YAML file
      def copy_yml
        template "config/regulate.yml", "config/regulate.yml"
      end

    protected

      # Check whether the current environment has HAML
      def verify_haml_existence
        begin
          require 'haml'
        rescue LoadError
          say "HAML is not installed, or it is not specified in your Gemfile."
          exit
        end
      end

      # Make sure we have the right HAML version
      def verify_haml_version
        unless Haml.version[:major] == 2 and Haml.version[:minor] >= 3 or Haml.version[:major] >= 3
          say "To generate HAML templates, you need to install HAML 2.3 or above."
          exit
        end
      end

      # Copy over the HAML files
      def create_and_copy_haml_views
        require 'tmpdir'
        html_root = "#{self.class.source_root}/app/views/regulate"

        Dir.mktmpdir("regulate-haml.") do |haml_root|
          Dir["#{html_root}/**/*"].each do |path|
            relative_path = path.sub(html_root, "")
            source_path   = (haml_root + relative_path).sub(/erb$/, "haml")

            if File.directory?(path)
              FileUtils.mkdir_p(source_path)
            else
              `html2haml -r #{path} #{source_path}`
            end
          end

          directory haml_root, "app/views/regulate"
        end
      end

    end # class ViewsGenerator

  end # module Generators

end # module Regulate

