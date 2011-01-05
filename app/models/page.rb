module Regulate

  class Page < Regulate::Git::Model::Base
    attributes :id, :commit_message, :author_name, :author_email, :title, :view, :custom_fields
    validates_presence_of :title, :view

    def title=(new_title)
      @title = new_title
      @id = self.title.gsub(%r{[ /<>]}, '-')
    end

  end

end

