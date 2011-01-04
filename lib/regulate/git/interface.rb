module Regulate

  module Git

    class Interface

      attr_reader :repo

      def initialize
        @repo = Grit::Repo.new(Regulate::Configuration.instance.repo)
      end

      def create_page(options = {})
        # Build up commit data
        commit = build_commit(options[:commit_message], 
                              options[:author_name], 
                              options[:author_email], 
                              :create)

        # Get the index
        index  = self.repo.index

        # Read the tree if we are on master
        if parent_commit = @repo.commit('master')
          index.read_tree(parent_commit.tree.id)
        end

        # Add the page with data
        puts page_path(options[:name], options[:format])
        index.add(page_path(options[:name], options[:format]), options[:content])

        # Determine if we have a parent so we can do stuff like git log
        parents = parent_commit ? [parent_commit] : []

        # Make a new commit and return the sha
        actor   = Grit::Actor.new(commit[:name], commit[:email])
        index.commit(commit[:message], parents, actor)
      end

      def update_page(options = {})

      end

      def find_page(name)

      end

      def delete_page(name)

      end

      def pages

      end

      def build_commit(commit_message, author_name, author_email, mode)
        {
          :name     => author_name     ||= "Anonymous",
          :email    => author_email    ||= "anon@anonymous.com",
          :messege  => commit_message  ||= mode.eql?(:create) ? "Creating new page." : "Updating page."
        }
      end

      def format_extension(format)
        case format
          when :markdown then 'md'
          when :textile  then 'textile'
          when :rdoc     then 'rdoc'
          when :org      then 'org'
          when :creole   then 'creole'
          when :rest     then 'rest'
          when :asciidoc then 'asciidoc'
          when :pod      then 'pod'
        end
      end

      def id(name)
        name.respond_to?(:gsub) ? name.gsub(%r{[ /<>]}, '-') : ''
      end

      def page_path(name, format)
        page_path = "/#{id(name)}.#{format_extension(format)}"
        page_path = page_path[1..-1] if page_path =~ /^\//
        page_path
      end

    end

  end

end

