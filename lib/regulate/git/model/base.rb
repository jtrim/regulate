module Regulate

  module Git

    module Model

      class Base
        # Standard ActiveModel includes so that our resources are Rails friendly
        include ActiveModel::Validations
        include ActiveModel::Conversion
        include ActiveModel::Serialization
        include ActiveModel::AttributeMethods
        extend  ActiveModel::Naming

        # The three fields that we absolutely need to successfully save and render any cms based model
        validates_presence_of :id, :title, :view

        # Standard class init
        #
        # @param [Hash] attributes Attributes to instantiate our resource with
        # @param [TrueClass,FalseClass] new_record Whether we are dealing with a new record or not
        def initialize( attributes = {} , new_record = true )
          @new_record = new_record
          assign_attributes(attributes)
        end

        # Delete our object from the git repo
        def destroy
          clear_cached_vars
          Regulate::Git::Interface.delete({
            :id => id,
            :commit_message => commit_message,
            :author_name => author_name,
            :author_email => author_email
          })
        end

        # Return a list of Grit::Commit objects for the given id
        def versions
          return @_versions ||= Regulate::Git::Interface.commits(id)
        end

        # Return the rendered.html file from the repo
        def rendered
          return @_rendered ||= Regulate::Git::Interface.find_rendered(id)
        end

        # Allow attributes to be mass assigned then saved
        #
        # @param [Hash] args Our attributes
        def update_attributes(args = {})
          assign_attributes(args)
          save
        end

        # Allow attributes to be mass assigned then saved
        # Will throw exceptions on error
        #
        # @param [Hash] args Our attributes
        def update_attributes!(args = {})
          assign_attributes(args)
          save!
        end

        # Attempt to save our record
        # @return [TrueClass,FalseClass] Whether or not the record was saved
        def save
          if new_record?
            return false if self.class.exists?(id)
          else
            return false unless self.class.exists?(id)
          end
          if valid?
            clear_cached_vars
            !!Regulate::Git::Interface.save({
              :id => id,
              :commit_message => commit_message,
              :author_name => author_name,
              :author_email => author_email,
              :attributes => attributes.to_json(:except => ['author_email', 'author_name', 'commit_message']),
              :rendered => build_rendered_html
            })
          else
            false
          end
        end

        # Attempt to save our record
        # Make sure we are throwing an exception on failure
        # @raise [Regulate::Git::Errors::DuplicatePageError] Throw this only if we are attempting to save a new_record and a resource with the given ID already exists
        # @raise [Regulate::Git::Errors::PageDoesNotExist] Throw this only if we are attempting to save an existing record and item does not already exist in the repo with the given ID
        # @raise [Regulate::Git::Errors::InvalidGitResourceError] Record is invalid and cannot save
        def save!
          if new_record?
            raise Regulate::Git::Errors::DuplicatePageError if Regulate::Git::Interface.exists?(id)
          else
            raise Regulate::Git::Errors::PageDoesNotExist unless Regulate::Git::Interface.exists?(id)
          end
          ( valid? ) ? save : raise(Regulate::Git::Errors::InvalidGitResourceError)
        end

        # Replaces mustache style syntax with appropriate instance attribute values
        #
        # @example Rendering a view for a git commit
        #   class MyModel < Regulate::Git::Model::Base
        #     attributes :my_fancy_subtitle
        #   end
        #   @my_model = MyModel.new
        #   @my_model.my_fancy_subtitle => "A Fancy Subtitle"
        #   @my_model.view = "<h3>{{my_fancy_subtitle}}</h3>"
        #   @my_model.build_rendered_html
        def build_rendered_html
          rendered = self.view
          rendered.gsub!( /\{\{(.+?)\}\}/ ) do |match|
            _attributes[$1]
          end
          rendered
        end

        # Are we dealing with a resource that has been persisted before?
        # @note Default is to return false
        def new_record?
          @new_record || false
        end

        # Some required ActiveModel magic to help define convenience functions for...
        #   'clear_' :: Clearing attributes
        #   '?'      :: Checking the existence of attributes
        attribute_method_prefix 'clear_'
        attribute_method_suffix '?'

        # Defining our _attributes container
        class_attribute :_attributes
        self._attributes = []

        # Create our _attributes hash by iterating through the list
        # This makes sure our _attributes hash has the most recent data from our instance variables then returns the hash
        #
        # @example Set Model Attributes
        #   class MyModel < Regulate::Git::Model::Base
        #     attributes :my_custom_attribute
        #   end
        #   @my_model = MyModel.new
        #   @my_model.my_custom_attribute = "my_custom_value"
        #   @my_model.attributes
        def attributes
          self._attributes.inject({}) do |hash, attr|
            hash[attr.to_s] = send(attr)
            hash
          end
        end

        # Our class methods
        class << self

          # This is setting smart attribute methods for our custom model attributes
          #
          # @example Setting Custom Model Attributes
          #   attributes :id, :commit_message, :author_name, :author_email, :title, :view, :custom_fields
          #
          # @param [Array] An array of attribute names as symbols
          def attributes(*names)
            attr_accessor *names
            define_attribute_methods names
            self._attributes += names
          end

          # Check whether or not an item in our repo already exists with the given ID
          #
          # @param [String] The ID to check for
          # @return [TrueClass,FalseClass] Whether or not the resource exists
          def exists?(id)
            return Regulate::Git::Interface.exists?(id)
          end

          # Search for by id, and return, a valid resource from the repo
          #
          # @todo Should we be raising an exception here?
          # @raise [Regulate::Git::Errors::PageDoesNotExist] Raise this if the find fails
          # @return An instance of whatever class extends this base class
          def find(id)
            resource_data = Regulate::Git::Interface.find(id) || raise(Regulate::Git::Errors::PageDoesNotExist)
            self.new(JSON.parse(resource_data),false)
          end

          # Search for by version, and return, a valid resource from the repo
          #
          # @todo Should we be raising an exception here?
          # @raise [Regulate::Git::Errors::PageDoesNotExist] Raise this if the find fails
          # @return an instance of whatever class extends this base class
          def find_by_version(version)
            resource_data = Regulate::Git::Interface.find_by_version(version) || raise(Regulate::Git::Errors::PageDoesNotExist)
            self.new(JSON.parse(resource_data),false)
          end

        end

        # These attributes will be required for all of our models, so we set them here
        attributes :id, :commit_message, :author_name, :author_email, :title, :view

        protected

        # ActiveModel required helper to remove an attribute by setting it to nil
        #
        # @param [Symbol] attribute The attribute to clear
        def clear_attribute( attribute )
          send("#{attribute}=", nil)
        end

        # ActiveModel required helper to check the existence of an attribute
        #
        # @param [Symbol] attribute The attribute name
        def attribute?( attribute )
          send(attribute).present?
        end

        # Method to accept a hash of model attributes and assign them to the attributes hash via the attr readers
        #
        # @param [Hash] args The hash of attributes
        def assign_attributes( args = {} )
          args.each do |attr, value|
            send("#{attr}=", value)
          end unless args.blank?
        end

        private

        # remove our cached vars so that they are reset on next call
        def clear_cached_vars
          @_rendered , @_versions = false , false
        end

        # Private var to make sure we are only calling our Git interface once
        attr_accessor :_rendered, :_versions

      end # class Base

    end # module Model

  end # module Git

end # module Regulate

