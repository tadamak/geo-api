module Swagger::MeshSchema
  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_schema :Mesh do
      key :required, [:code, :level, :details]
      property :code do
        key :type, :string
        key :example, '5339452922'
      end
      property :level do
        key :type, :integer
        key :example, 5
      end
      property :details do
        key :type, :array
        items do
          property :code do
            key :type, :string
          end
          property :level do
            key :type, :integer
          end
        end
        key :example, [
          {code: '5339', level: 1},
          {code: '533945', level: 2},
          {code: '53394529', level: 3},
          {code: '533945292', level: 4},
          {code: '5339452922', level: 5}
        ]
      end
    end
  end
end
