module Swagger::StationSchema
  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_schema :Station do
      key :required, [:code, :name, :location, :address]
      property :code do
        key :type, :string
        key :description, '駅コード'
        key :example, 'st-xn76urx01'
      end
      property :name do
        key :type, :string
        key :description, '駅名称'
        key :example, '東京'
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
      property :distance do
        key :type, :integer
        key :example, 100
        key :description, '基点からの直線距離(m)。範囲検索時のみ出力。'
      end
      property :address do
        key :'$ref', :Address
      end
    end
  end
end
