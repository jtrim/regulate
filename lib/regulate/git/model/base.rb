module Regulate

  module Git

    module Model

      class Base
        include ActiveModel::Validations
        include ActiveModel::Conversion
        extend ActiveModel::Naming

        attr_accessor :id, :commit_message, :author_name, :author_email, :title, :view, :content
        validates_presence_of :title

        def initialize(attributes = {})
          assign_attributes(attributes)
        end

        def persisted?
          !id.blank?
        end

        def id
          self.title.respond_to?(:gsub) ? self.title.gsub(%r{[ /<>]}, '-') : self.title
        end

        def build_attributes_json
          "{ 'test' : 'test' }"
        end

        def build_rendered_html
          '<h1>Test</h1>'
        end

        def create
          Regulate::Git::Interface.create({
            :id => id,
            :commit_message => commit_message,
            :author_name => author_name,
            :author_email => author_email,
            :attributes => build_attributes_json,
            :rendered => build_rendered_html
          })
        end

        def update_attributes(attributes = {})
          assign_attributes(attributes)
        end

        def destroy
        end

        def self.find(name)
        end

      private

        def assign_attributes(attributes = {})
          attributes.each do |name, value|
            send("#{name}=", value)
          end
        end

      end

    end

  end

end

