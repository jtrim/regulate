module Regulate

  module Git

    # The module that will hold all Git related errors
    module Errors

      # Used when attempting to save a Git resource that already exists
      class DuplicatePageError < StandardError; end

      # Used when there is a problem with a Git resource
      class InvalidGitResourceError < StandardError; end

      # Used when attempting to persist a Git resource that doesn't already exist
      class PageDoesNotExist < StandardError; end

    end

  end

end

