module Regulate

  module Git

    class Interface

      class << self

        def commits(id)
          Regulate.repo.log( 'master' , id )
        end

        def find(id)
          ( Regulate.repo.tree / File.join( id , 'attributes.json' ) ).data
        end

        def find_by_version(version)
          Regulate.repo.blob(version).data
        end

        # Expected options
        #Regulate::Git::Interface.create({
          #:id => id,
          #:commit_message => commit_message,
          #:author_name => author_name,
          #:author_email => author_email,
          #:attributes => build_attributes_json,
          #:rendered => build_rendered_html
        #})
        def save(options = {})
          commit( options , :create) do |index|
            index.add(File.join(options[:id], 'attributes.json'), options[:attributes])
            index.add(File.join(options[:id], 'rendered.html'), options[:rendered])
          end
        end

        def delete(options = {})
          commit( options , :delete ) do |index|
            # Delete the folder that holds the attributes and the render.html
            index.delete(File.join(options[:id],'attributes.json'))
            index.delete(File.join(options[:id],'rendered.html'))
          end
        end

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
        # @see https://github.com/github/gollum/blob/master/lib/gollum/wiki.rb
        def update_working_dir( index, path )
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
        # @see https://github.com/github/gollum/blob/master/lib/gollum/wiki.rb
        def file_path_scheduled_for_deletion?(map, path)
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


        def build_commit(commit_message, author_name, author_email, mode)
          {
            :name     => author_name.nil? ? "Anonymous" : author_name,
            :email    => author_email    ||= "anon@anonymous.com",
            :message  => commit_message  ||= mode.eql?(:create) ? "Creating new page." : "Updating page."
          }
        end

        def exists?(id)
          Regulate.repo.commits.any? && !(current_tree / File.join(id, 'attributes.json')).nil?
        end

        def last_commit
          branch = 'master'
          return nil unless Regulate.repo.commits(branch).any?

          # We should be able to use just repo.commits(branch).first here but
          # this is a workaround for this bug: 
          # http://github.com/mojombo/grit/issues/issue/38
          Regulate.repo.commits("#{branch}^..#{branch}").first || Regulate.repo.commits(branch).first
        end

        def current_tree
          c = last_commit
          c ? c.tree : nil
        end

      end

    end

  end

end

