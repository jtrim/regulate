module Regulate
  class Engine < Rails::Engine

    initializer 'regulate.load_app_instance_data' do |app|
      Regulate.setup do |config|

        # Set our host app root path
        config.app_root = Rails.root

        # Check for the existence of a custom YAML file in the host app
        if( File.exists?( File.join( config.app_root , 'config' , 'regulate.yml') ) )
          yaml_path = File.join(config.app_root, "config", "regulate.yml")
        else
          # Use the provided default
          yaml_path = File.join(root , "config", "regulate.yml")
        end

        yaml_data = YAML.load_file(yaml_path)[Rails.env]

        # Now set our repo
        config.repo = yaml_data['repo']

      end
    end

  end
end
