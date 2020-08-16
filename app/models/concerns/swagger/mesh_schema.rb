module Swagger::MeshSchema
  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_schema :Mesh do
      key :required, [:code, :level, :details]
      property :code do
        key :type, :string
        key :example, '3036'
      end
      property :level do
        key :type, :integer
        key :example, 3
      end
      property :details do
        key :type, :array
        items do
          property :code do
            key :type, :string
            key :example, '3036'
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
