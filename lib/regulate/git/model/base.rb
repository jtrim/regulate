module Regulate

  module Git

    module Model

      class Base
        include ActiveModel::Validations
        include ActiveModel::Conversion
        include ActiveModel::Serialization
        include ActiveModel::AttributeMethods
        extend  ActiveModel::Naming

        def initialize(attributes = {})
          attributes.each do |attr, value|
            self.send("#{attr}=", value)
          end unless attributes.blank?
        end

        def destroy
        end

        def self.find(name)
        end

        def create
          Regulate::Git::Interface.create({
            :id => id,
            :commit_message => commit_message,
            :author_name => author_name,
            :author_email => author_email,
            :attributes => attributes.to_json(:only => ['title', 'id', 'view', 'content']),
            :rendered => build_rendered_html
          }) if valid?
        end

        def persisted?
          !id.blank?
        end

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

      end

    end

  end

end

