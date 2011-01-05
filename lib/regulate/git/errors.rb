module Regulate

  module Git

   module Errors

     class DuplicatePageError < StandardError; end

     class InvalidGitResourceError < StandardError; end

     class PageDoesNotExist < StandardError; end

   end

  end

end

