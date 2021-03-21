module Swagger::AnalyticsApi
  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_path '/analytics/addresses/contains' do
      operation :post do
        key :description, '指定した緯度経度がどのポリゴン内に含まれているかを解析し、住所毎の件数を取得します。'
        key :tags, ['Analytics']
        security do
          key :access_token, []
        end
        parameter name: :body do
          key :in, :body
          key :description, "緯度経度の配列と住所レベル。配列の最大数は#{Constants::ANALYTICS_MAX_LIMIT}。"
          key :required, true
          schema do
            key :type, :object
            property :locations do
              key :type, :array
              items do
                key :type, :string
              end
              key :example, [ { "lat": 35.68151, "lng": 139.76699 }, { "lat": 35.68956, "lng": 139.69171 } ]
            end
            property :level do
              key :type, :integer
              key :example, 3
            end
          end
        end

        response 200 do
          key :description, '住所毎の件数'
          schema do
            key :type, :array
            items do
              key :required, [:address_code, :address_name, :count]
              property :address_code do
                key :type, :string
                key :example, '13'
              end
              property :address_name do
                key :type, :string
                key :example, '東京都'
              end
              property :count do
                key :type, :integer
                key :example, 2
              end
            end
          end
        end

        response 400 do
          key :description, 'Error'
          schema do
            property :error do
              key :'$ref', :Error
            end
          end
        end
      end
    end
  end
end
