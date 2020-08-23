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
              key :example, 'MultiPolygon'
            end
            property :coordinates do
              key :type, :array
              items do
                key :type, :array
                items do
                  key :type, :array
                  items do
                    key :type, :array
                    items do
                      key :type, :number
                      key :format, :float
                    end
                  end
                  key :example, [
                    [139.77286583700004, 35.70370213500004],
                    [139.77279358, 35.70312019800003],
                    [139.77366136200004, 35.70303991899996]
                  ]  
                end
              end
            end
          end
        end
      end
    end
  end
end
