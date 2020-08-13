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
          key :description, "緯度経度(カンマ区切り)の配列と住所レベル。配列の最大数は#{Constants::ANALYTICS_MAX_LIMIT}。"
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
              key :example, 1
            end
          end
        end

        response 200 do
          key :description, '住所毎の件数'
          schema do
            key :type, :array
            items do
              key :required, [:address, :count]
              property :address do
                key :'$ref', :Address
              end
              property :count do
                key :type, :integer
                key :example, 5
              end
            end
          end
        end

        response 400 do
          schema do
            property :error do
              key :'$ref', :Error
            end
          end
        end
      end
    end

    swagger_path '/analytics/meshes/contains' do
      operation :post do
        key :description, '指定した緯度経度がどのポリゴン内に含まれているかを解析し、地域メッシュ毎の件数を取得します。'
        key :tags, ['Analytics']
        parameter name: :body do
          key :in, :body
          key :description, "緯度経度(カンマ区切り)の配列と地域メッシュレベル。配列の最大数は#{Constants::ANALYTICS_MAX_LIMIT}。"
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
              key :example, 1
            end
          end
        end

        response 200 do
          key :description, '地域メッシュ毎の件数'
          schema do
            key :type, :array
            items do
              key :required, [:mesh, :count]
              property :mesh do
                key :'$ref', :Mesh
              end
              property :count do
                key :type, :integer
                key :example, 5
              end
            end
          end
        end

        response 400 do
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
