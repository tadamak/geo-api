module Swagger::AddressSchema
  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_schema :Address do
      key :required, [:code, :name, :level, :location, :details]
      property :code do
        key :type, :string
        key :example, '13101001001'
      end
      property :name do
        key :type, :string
        key :example, '東京都千代田区丸の内１丁目'
      end
      property :level do
        key :type, :integer
        key :example, 3
      end
      property :location do
        key :type, :object
        property :lat do
          key :type, :number
          key :format, :float
          key :example, 35.68151
        end
        property :lng do
          key :type, :number
          key :format, :float
          key :example, 139.76699
        end
      end
      property :details do
        key :type, :array
        items do
          property :code do
            key :type, :string
          end
          property :name do
            key :type, :string
          end
          property :level do
            key :type, :integer
          end
        end
        key :example, [
          {code: '13', name: '東京都', level: 1},
          {code: '13101', name: '千代田区', level: 2},
          {code: '13101001001', name: '丸の内１丁目', level: 3}
        ]
      end
    end
  end
end
