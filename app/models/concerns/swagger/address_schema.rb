module Swagger::AddressSchema
  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_schema :Address do
      key :required, [:code, :name, :level, :location, :details]
      property :code do
        key :type, :string
        key :example, '13'
      end
      property :name do
        key :type, :string
        key :example, '東京都'
      end
      property :level do
        key :type, :integer
        key :example, 1
      end
      property :location do
        key :type, :object
        property :lat do
          key :type, :number
          key :format, :float
          key :example, 35.689568
        end
        property :lng do
          key :type, :number
          key :format, :float
          key :example, 139.691717
        end
      end
      property :details do
        key :type, :array
        items do
          property :code do
            key :type, :string
            key :example, '13'
          end
          property :name do
            key :type, :string
            key :example, '東京都'
          end
          property :level do
            key :type, :integer
            key :example, 1
          end
        end
      end
    end
  end
end
