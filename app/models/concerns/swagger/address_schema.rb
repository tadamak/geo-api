module Swagger::AddressSchema
  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_schema :Address do
      key :required, [:code, :name, :level, :location, :area, :details]
      property :code do
        key :type, :string
        key :description, '住所コード'
        key :example, '13101001001'
      end
      property :name do
        key :type, :string
        key :description, '住所名称'
        key :example, '東京都千代田区丸の内１丁目'
      end
      property :level do
        key :type, :integer
        key :example, 3
        key :description, '住所レベル'
      end
      property :location do
        key :type, :object
        key :required, [:lat, :lng]
        property :lat do
          key :type, :number
          key :format, :float
          key :description, '代表地点の緯度'
          key :example, 35.68151
        end
        property :lng do
          key :type, :number
          key :format, :float
          key :description, '代表地点の経度'
          key :example, 139.76699
        end
      end
      property :area do
        key :type, :integer
        key :example, 379202
        key :description, '面積(㎡)'
      end
      property :details do
        key :type, :array
        key :description, 'レベル毎の住所情報'
        items do
          property :code do
            key :type, :string
            key :description, '住所コード'
            key :example, '13101'
          end
          property :name do
            key :type, :string
            key :description, '住所名称'
            key :example, '千代田区'
          end
          property :kana do
            key :type, :string
            key :description, '住所読み仮名'
            key :example, 'ちよだく'
          end
          property :level do
            key :type, :integer
            key :description, '住所レベル'
            key :example, 2
          end
        end
      end
      property :distance do
        key :type, :integer
        key :example, 100
        key :description, '基点からの直線距離(m)。範囲検索時のみ出力。'
      end
    end
  end
end
