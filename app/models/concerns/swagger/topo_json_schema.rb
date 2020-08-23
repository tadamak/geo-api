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
            key :type, :number
            key :format, :float
          end 
          key :example, [[813993, 953840], [-1372, -16285], [16479, -2247]]
        end
      end
      property :bbox do
        key :type, :array
        items do
          key :type, :number
          key :format, :float
        end
        key :example, [139.730001362, 35.669617468, 139.78266080400002, 35.705351586]
      end
      property :transform do
        key :required, [:scale, :translate]
        property :scale do
          key :type, :array
          items do
            key :type, :number
            key :format, :float
          end
          key :example, [5.265949465951549e-8, 3.5734153734154326e-8]
        end
        property :translate do
          key :type, :array
          items do
            key :type, :number
            key :format, :float
          end
          key :example, [139.730001362, 35.669617468]
        end
      end
      property :objects do
        key :required, [:address]
        property :address do
          property :type do
            key :type, :string
            key :example, 'GeometryCollection'
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
                property :code do
                  key :type, :string
                  key :example, '13101'
                end
              end
            end
          end  
        end
      end
    end
  end
end
