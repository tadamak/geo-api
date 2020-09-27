module Swagger::SchoolDistrictSchema
  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_schema :SchoolDistrict do
      key :required, [:code, :address_code, :school_code, :school_type, :school_name, :school_address, :location]
      property :code do
        key :type, :integer
        key :example, 'sd-1-xn77h66rv'
        key :description, '学区コード'
      end
      property :address_code do
        key :type, :string
        key :example, '13101024001'
        key :description, '学区が含まれる住所コード'
      end
      property :school_code do
        key :type, :string
        key :example, 'sc-13-xn77h6d2n'
        key :description, '学校コード'
      end
      property :school_type do
        key :type, :integer
        key :example, 1
        key :description, '学校種別 (1: 小学校, 2: 中学校)'
      end
      property :school_name do
        key :type, :string
        key :example, 'お茶の水小学校'
        key :description, '学校名称'
      end
      property :school_address do
        key :type, :string
        key :example, '千代田区猿楽町1-1-1'
        key :description, '学校住所名称'
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
    end
  end
end
