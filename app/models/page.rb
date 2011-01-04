module Regulate

  class Page < Regulate::Git::Model::Base
    attr_accessor :title, :view, :content
    validates_presence_of :title
  end

end

