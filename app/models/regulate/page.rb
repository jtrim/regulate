module Regulate

  # The standard model for our CMS engine
  class Page < Regulate::Git::Model::Base

    # A title= override so that we are setting a URI-friendly id
    #
    # @param [String] The new title of our page
    # @return [NilClass]
    def title=(new_title)
      @title = new_title
      # Make sure that we're setting our ID.
      # This needs to be URI-friendly
      #@id = self.title.gsub(%r{[ /<>]}, '-').downcase
      @id = self.title.gsub(/[^a-zA-Z0-9]+/, "-").chomp('-').reverse.chomp('-').reverse.downcase
    end

  end

end

