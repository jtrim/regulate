module Regulate

  # Our instance of the Rails::Engine class that will allow us to load our functionality
  # in to a host app
  class Engine < Rails::Engine

    initializer 'regulate.load_app_instance_data' do |app|

      Regulate.setup do |config|

        # Set our host app root path
        config.app_root = Rails.root

        # Check for the existence of a custom YAML file in the host app
        if( File.exists?( File.join( config.app_root , 'config' , 'regulate.yml') ) )
          yaml_path = File.join(config.app_root, "config", "regulate.yml")
        else
          # Use the provided default in our gem
          yaml_path = File.join(root , "config", "regulate.yml")
        end

        yaml_data = YAML.load_file(yaml_path)[Rails.env]

        # Now set our repo
        repo_path = File.join(config.app_root, yaml_data['repo'])
        repo = File.join(repo_path, ".git")
        init = false

        if !File.directory?(repo_path)
          FileUtils.mkdir_p(repo_path)
          init = true
        elsif !File.directory?(repo)
          init = true
        end

        ::Grit::Repo.init(repo_path) if init
        config.repo = ::Grit::Repo.new(repo_path)

      end

    end

    initializer "static assets" do |app|
      app.middleware.use ::ActionDispatch::Static, "#{root}/public"
    end

  end # class Engine

end # module Regulate

