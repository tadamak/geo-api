module Swagger::MeshSchema
  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_schema :Mesh do
      key :required, [:code, :level]
      property :code do
        key :type, :string
        key :example, '30365090'
      end
      property :level do
        key :type, :integer
        key :example, 3
      end
    end
  end
end
