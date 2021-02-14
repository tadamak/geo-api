module Swagger::SchoolSchema
  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_schema :School do
      key :required, [:code, :name, :school_type, :school_admin, :school_address, :address_code, :location, :school_district_code]
      property :code do
        key :type, :string
        key :example, 'sc-13-xn77h6d2n'
        key :description, '学校コード'
      end
      property :name do
        key :type, :string
        key :example, 'お茶の水小学校'
        key :description, '学校名称'
      end
      property :school_type do
        key :type, :integer
        key :example, 1
        key :description, '学校種別 (1: 小学校, 2: 中学校, 3: 中等教育学校, 4: 高等学校, 5: 高等専門学校, 6: 短期大学, 7: 大学, 8: 特別支援学校)'
      end
      property :school_admin do
        key :type, :integer
        key :example, 3
        key :description, '学校管理 (1: 国, 2: 都道府県, 3: 市区町村, 4: 民間, 0: その他)'
      end
      property :school_address do
        key :type, :string
        key :example, '猿楽町1-1-1'
        key :description, '学校住所'
      end
      property :address_code do
        key :type, :string
        key :example, '13101024001'
        key :description, '住所コード'
      end
      property :location do
        key :type, :object
        property :lat do
          key :type, :number
          key :format, :float
          key :example, 35.68151
          key :description, '学校の緯度'
        end
        property :lng do
          key :type, :number
          key :format, :float
          key :example, 139.76699
          key :description, '学校の経度'
        end
      end
      property :school_district_code do
        key :type, :string
        key :example, 'sd-1-xn77h66rv'
        key :description, '学区コード'
      end
      property :distance do
        key :type, :integer
        key :example, 100
        key :description, '基点からの直線距離(m)。範囲検索時のみ出力。'
      end
    end
  end
end
