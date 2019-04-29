module Swagger::GeoJsonSchema
  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_schema :GeoJson do
      key :required, [:type, :features]
      property :type do
        key :type, :string
        key :example, 'FeatureCollection'
      end
      property :features do
        key :type, :array
        items do
          key :type, :object
          key :required, [:type, :properties, :geometry]
          property :type do
            key :type, :string
            key :example, 'Feature'
          end
          property :properties do
            key :type, :object
            property :code do
              key :type, :string
              key :example, '13101'
            end
          end
          property :geometry do
            key :type, :object
            key :required, [:type, :coordinates]
            property :type do
              key :type, :string
              key :example, 'Polygon'
            end
            property :coordinates do
              key :type, :array
              items do
                key :type, :number
                key :format, :float
              end
              key :examples, [139.77286583728858, 35.70370213544527]
            end
          end
        end
      end
    end
  end
end
