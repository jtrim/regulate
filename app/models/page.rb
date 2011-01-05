module Regulate

  class Page < Regulate::Git::Model::Base
    attributes :id, :commit_message, :author_name, :author_email, :title, :view, :content
    validates_presence_of :title, :view, :content

    def build_rendered_html
      '<h1>Test</h1>'
    end

    def title=(new_title)
      @title = new_title
      @id = self.title.gsub(%r{[ /<>]}, '-')
    end

  end

end

