module Regulate

  module Git

    # The class that we'll use to interact with our Git repositories
    class Interface

      class << self

        # Find all commits for a given id
        # Essentially looks for all folders in our repo whose names match the given id
        #
        # @param [String] id The id to search for
        # @return [Array] An array of Grit::Commit objects
        def commits( id )
          Regulate.repo.log( 'master' , id )
        end

        # Find and return relavant data for a given id
        #
        # @param [String] id The id to search for
        # @return [String] The contents of the attributes.json file for the given id
        def find( id )
          begin
            ( Regulate.repo.tree / File.join( id , 'attributes.json' ) ).data
          rescue
            nil
          end
        end

        # Return an array of attributes.json data strings for all IDs in the repo
        #
        # @return [Array] An array of JSON strings
        def find_all
          Regulate.repo.tree.contents.collect { |tree|
            attributes_json = ( tree / 'attributes.json' )
            attributes_json.data unless attributes_json.nil?
          }.compact
        end

        # Find and return the rendered HTML for a given id
        #
        # @param [String] id The id to search for
        # @return [String] The contents of the rendered.html file for the given id
        def find_rendered( id )
          begin
            ( Regulate.repo.tree / File.join( id , 'rendered.html' ) ).data
          rescue
            nil
          end
        end

        # Find the contents of a file given it's version SHA
        # @param [String] version The version SHA hash of the blob
        # @return [String] The contents of the blob at that version
        def find_by_version( id , version )
          begin
            ( Regulate.repo.commit(version).tree / File.join( id , 'attributes.json' ) ).data
          rescue
            nil
          end
        end

        # Save changes to a resource directory with a commit
        # All of the keys in the example are expected!
        #
        # @param [Hash] options A hash containing all the data we'll need to make a commit
        # @example A sample save call
        #   Regulate::Git::Interface.save({
        #     :id => id,
        #     :commit_message => commit_message,
        #     :author_name => author_name,
        #     :author_email => author_email,
        #     :attributes => attributes_json,
        #     :rendered => rendered_html
        #   })
        def save( options = {} )
          # Begin a commit operation
          commit( options , :create ) do |index|
            # Persist changes to both of our needed files
            index.add(File.join(options[:id], 'attributes.json'), options[:attributes])
            index.add(File.join(options[:id], 'rendered.html'), options[:rendered])
          end
        end

        # Delete a resource directory with a commit
        # All of the keys in the example are expected!
        #
        # @param [Hash] options A hash containing all the data we'll need to make a commit
        # @example A sample delete call
        #   Regulate::Git::Interface.delete({
        #     :id => id,
        #     :commit_message => commit_message,
        #     :author_name => author_name,
        #     :author_email => author_email
        #   })
        def delete( options = {} )
          # Begin a commit operation
          commit( options , :delete ) do |index|
            # Delete both of our files in the resource directory to delete the directory
            index.delete(File.join(options[:id],'attributes.json'))
            index.delete(File.join(options[:id],'rendered.html'))
          end
        end

        # Create a commit
        #
        # @param [Hash] options A hash containing all the data we'll need to make a commit
        # @param [Symbol] type The type of commit that we're making - used to create commit messages and set other standard data
        # @param [Proc] &blk The meat of the commit to be performed in other convenience functions
        # @yield [index] Our actual commit operations performed in their respective convenience functions
        # @yieldparam [Grit::Index] Our repo index
        def commit( options , type , &blk )
          # Build up commit data
          commit = build_commit(options[:commit_message],
                                options[:author_name],
                                options[:author_email],
                                type)

          # Get the index
          index  = Regulate.repo.index

          # Read the tree if we are on master
          if parent_commit = Regulate.repo.commit('master')
            index.read_tree(parent_commit.tree.id)
          end

          yield index

          # Determine if we have a parent so we can do stuff like git log
          parents = parent_commit ? [parent_commit] : []

          # Make a new commit and return the sha
          actor   = Grit::Actor.new(commit[:name], commit[:email])
          sha     = index.commit(commit[:message], parents, actor)

          # Update our working directory so that the repo truly reflects the desired state
          # Do this for each of our files that we might have made changes to
          update_working_dir( index, File.join(options[:id],'attributes.json') )
          update_working_dir( index, File.join(options[:id], 'rendered.html') )

          sha
        end

        # Update the given file in the repository's working directory if there
        # is a working directory present.
        #
        # index  - The Grit::Index with which to sync.
        # dir    - The String directory in which the file lives.
        # name   - The String name of the page (may be in human format).
        # format - The Symbol format of the page.
        #
        # Returns nothing.
        # @see https://github.com/github/gollum/blob/79a1fb860d261d7f836fe75f5f8b4b88fc541a0c/lib/gollum/wiki.rb#L417
        #
        # @param [Grit::Index] index The git index that we are working on
        # @param [String] path The path/path-to-file that we want to update to represent the true state of the repo
        # @return [NilClass]
        def update_working_dir( index , path )
          unless Regulate.repo.bare
            Dir.chdir(::File.join(Regulate.repo.path, '..')) do
              if file_path_scheduled_for_deletion?(index.tree, path)
                Regulate.repo.git.rm({'f' => true}, '--', path)
              else
                Regulate.repo.git.checkout({}, 'HEAD', '--', path)
              end
            end
          end
        end

        # Determine if a given file is scheduled to be deleted in the next commit
        # for the given Index.
        #
        # map   - The Hash map:
        #         key - The String directory or filename.
        #         val - The Hash submap or the String contents of the file.
        # path - The String path of the file including extension.
        #
        # Returns the Boolean response.
        # @see https://github.com/github/gollum/blob/79a1fb860d261d7f836fe75f5f8b4b88fc541a0c/lib/gollum/wiki.rb#L459
        #
        # @param [Grit::Tree] map The tree containing our path that we are checking
        # @param [String] path The path/path-to-file to check
        # @return [TrueClass,FalseClass]
        def file_path_scheduled_for_deletion?( map , path )
          parts = path.split('/')
          if parts.size == 1
            deletions = map.keys.select { |k| !map[k] }
            deletions.any? { |d| d == parts.first }
          else
            part = parts.shift
            if rest = map[part]
              file_path_scheduled_for_deletion?(rest, parts.join('/'))
            else
              false
            end
          end
        end


        # Setup some standard commit data
        #
        # @param [String] commit_message Our commit message
        # @param [String] author_name Our author name
        # @param [String] author_email Our author email
        # @param [String] mode The type of action being taken in the commit
        def build_commit( commit_message , author_name , author_email , mode )
          {
            :name     => author_name.nil? ? "Anonymous" : author_name,
            :email    => author_email    ||= "anon@anonymous.com",
            :message  => commit_message  ||= mode.eql?(:create) ? "Creating new page." : "Updating page."
          }
        end

        # Return whether or not a resource directory exists in the repo with the given ID
        #
        # @param [String] id The ID that we are checking
        # @return [TrueClass,FalseClass]
        def exists?( id )
          Regulate.repo.commits.any? && !(current_tree / File.join(id, 'attributes.json')).nil?
        end

        # Return a commit object representing the last commit on the active repo
        #
        # @return [Grit::Commit] A Grit::Commit object representing the most recent commit on the active repository
        def last_commit
          branch = 'master'
          return nil unless Regulate.repo.commits(branch).any?

          # We should be able to use just repo.commits(branch).first here but
          # this is a workaround for this bug: 
          # http://github.com/mojombo/grit/issues/issue/38
          Regulate.repo.commits("#{branch}^..#{branch}").first || Regulate.repo.commits(branch).first
        end

        # The tree for the last commit on the active repo
        def current_tree
          c = last_commit
          c ? c.tree : nil
        end

      end # Interface class methods ( class << self )

    end # class Interface

  end # module Git

end # module Regulate

