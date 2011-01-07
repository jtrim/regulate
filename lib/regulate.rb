# Requires
require 'active_support/dependencies'

# Our top level module to contain all of our engine gem functionality
module Regulate

  # Autoloads
  autoload :Git , 'regulate/git'

  # Our host application root path
  # We set this when the engine is initialized
  mattr_accessor :app_root

  # The repo we'll be using
  # We set this when the engine is initialized
  mattr_accessor :repo

  # Route namespace
  mattr_accessor :route_namespace
  @@route_namespace = "cms"

  # Yield self on setup for nice config blocks
  def self.setup
    yield self
  end

end # module Regulate

# Requires
require 'regulate/engine' if defined?(Rails)
