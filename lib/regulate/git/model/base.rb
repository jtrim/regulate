module Regulate

  module Git

    module Model

      class Base
        include ActiveModel::Validations
        include ActiveModel::Conversion
        include ActiveModel::Serialization
        include ActiveModel::AttributeMethods
        extend  ActiveModel::Naming

        def initialize( attributes = {} , new_record = true )
          @new_record = new_record
          @custom_fields = {}
          assign_attributes(attributes)
        end

        def destroy
          Regulate::Git::Interface.delete({
            :id => id,
            :commit_message => commit_message,
            :author_name => author_name,
            :author_email => author_email
          })
        end

        def self.find(id)
          resource_data = Regulate::Git::Interface.find(id) || raise(Regulate::Git::Errors::PageDoesNotExist)
          self.new(JSON.parse(resource_data),false)
        end

        def self.find_by_version(version)
          resource_data = Regulate::Git::Interface.find_by_version(version) || raise(Regulate::Git::Errors::PageDoesNotExist)
          self.new(JSON.parse(resource_data),false)
        end

        def versions
          Regulate::Git::Interface.commits(id)
        end

        def update_attributes(args = {})
          assign_attributes(args)
          save
        end

        def update_attributes!(args = {})
          assign_attributes(args)
          save!
        end

        def save
          if new_record?
            raise Regulate::Git::Errors::DuplicatePageError if Regulate::Git::Interface.exists?(id)
          else
            raise Regulate::Git::Errors::PageDoesNotExist unless Regulate::Git::Interface.exists?(id)
          end

          if valid?
            Regulate::Git::Interface.save({
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

        def save!
          ( valid? ) ? save : raise(Regulate::Git::Errors::InvalidGitResourceError)
        end

        def build_rendered_html
          rendered = self.view
          rendered.gsub!( /\{\{(.+?)\}\}/ ) do |match|
            custom_fields[$1]
          end
          rendered
        end

        def new_record?
          @new_record || false
        end

        #def persisted?
          #!id.blank?
        #end

        class_attribute :_attributes
        self._attributes = []

        attribute_method_prefix 'clear_'
        attribute_method_suffix '?'

        def self.attributes(*names)
          attr_accessor *names
          define_attribute_methods names

          self._attributes += names
        end

        def attributes
          self._attributes.inject({}) do |hash, attr|
            hash[attr.to_s] = send(attr)
            hash
          end
        end

        protected

        def clear_attribute(attribute)
          send("#{attribute}=", nil)
        end

        def attribute?(attribute)
          send(attribute).present?
        end

        def assign_attributes(args = {})
          args.each do |attr, value|
            send("#{attr}=", value)
          end unless args.blank?
        end
      end

    end

  end

end

