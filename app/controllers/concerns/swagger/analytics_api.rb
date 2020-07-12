module Swagger::AnalyticsApi
  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_path '/analytics/addresses/contains' do
      operation :post do
        key :description, '指定した緯度経度がどのポリゴン内に含まれているかを解析し、住所毎の件数を取得します。'
        key :tags, ['Analytics']
        parameter name: :body do
          key :in, :body
          key :description, '緯度経度(カンマ区切り)の配列と住所レベル'
          key :required, true
          schema do
            key :type, :object
            property :locations do
              key :type, :array
              items do
                key :type, :string
                key :example, '35.689568,139.691717'
              end
            end
            property :level do
              key :type, :integer
              key :format, :int32
              key :example, 1
            end
          end
        end

        response 200 do
          key :description, '住所毎の件数'
          schema do
            key :type, :array
            items do
              key :required, [:address_code, :count]
              property :address do
                key :'$ref', :Address
              end
              property :count do
                key :type, :integer
                key :format, :int32
                key :example, 5
              end
            end
          end
        end
      end
    end
  end
end
