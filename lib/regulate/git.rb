# Requires
require 'grit'

module Regulate

  # Our module to contain all get related functionality
  module Git

    # Autoloads
    autoload :Errors    , 'regulate/git/errors'
    autoload :Model     , 'regulate/git/model'
    autoload :Interface , 'regulate/git/interface'

  end # module Git

end # module Regulate

