module Swagger::LineSchema
  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_schema :Line do
      key :required, [:code, :name, :company_name, :location]
      property :code do
        key :type, :string
        key :description, '路線コード'
        key :example, 'st-xn76urx01'
      end
      property :name do
        key :type, :string
        key :description, '路線名称'
        key :example, '千代田線'
      end
      property :company_name do
        key :type, :string
        key :description, '会社名称'
        key :example, '東京メトロ'
      end
      property :location do
        key :type, :object
        key :required, [:lat, :lng]
        property :lat do
          key :type, :number
          key :format, :float
          key :description, '代表地点の緯度'
          key :example, 35.68085420935481
        end
        property :lng do
          key :type, :number
          key :format, :float
          key :description, '代表地点の経度'
          key :example, 139.76676483469222
        end
      end
      property :stations do
        key :type, :array
        items do
          key :'$ref', :Station
        end
      end
    end
  end
end
