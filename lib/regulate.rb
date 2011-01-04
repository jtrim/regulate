# Requires
require 'active_support/dependencies'

module Regulate

  # Autoloads
  autoload :Git , 'regulate/git'

  # Our host application root path
  mattr_accessor :app_root

  # The repo we'll be using
  mattr_accessor :repo

  def self.setup
    yield self
  end
end

# Requires
require 'regulate/engine' if defined?(Rails)
