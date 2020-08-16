module Swagger::TopoJsonSchema
  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_schema :TopoJson do
      key :required, [:type, :arcs, :bbox, :transform, :translate, :objects]
      property :type do
        key :type, :string
        key :example, 'Topology'
      end
      property :arcs do
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
        end
      end
      property :bbox do
        key :type, :array
        items do
          key :type, :number
          key :format, :float
        end
      end
      property :transform do
        key :required, [:scale, :translate]
        property :scale do
          key :type, :array
          items do
            key :type, :number
            key :format, :float
          end
        end
        property :translate do
          key :type, :array
          items do
            key :type, :number
            key :format, :float
          end
        end
      end
      property :objects do
        key :required, [:address, :geometries]
        property :address do
          property :type do
            key :type, :string
            key :example, 'GeometryCollection'
          end
        end
        property :geometries do
          key :type, :array
          items do
            key :type, :object
            key :required, [:arcs, :type, :properties]
            property :arcs do
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
              end
            end
            property :type do
              key :type, :string
              key :example, 'MultiPolygon'
            end
            property :properties do
              key :type, :object
            end
          end
        end
      end
    end
  end
end
