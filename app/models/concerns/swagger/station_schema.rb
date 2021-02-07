module Swagger::StationSchema
  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_schema :Station do
      key :required, [:code, :name, :address_code, :address_name, :location]
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
      property :address_code do
        key :type, :string
        key :description, '住所コード'
        key :example, '13101001001'
      end
      property :address_name do
        key :type, :string
        key :description, '住所名称'
        key :example, '東京都千代田区丸の内１丁目'
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
    end
  end
end
