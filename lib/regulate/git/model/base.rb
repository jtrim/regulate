module Regulate

  module Git

    module Model

      class Base
        include ActiveModel::Validations
        include ActiveModel::Conversion
        extend ActiveModel::Naming

        attr_accessor :id, :commit_message, :author_name, :author_email

        def initialize(attributes = {})
          assign_attributes(attributes)
        end

        def persisted?
          !id.blank?
        end

        def id
        end

        def save
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

