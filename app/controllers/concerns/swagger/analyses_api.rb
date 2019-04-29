module Swagger::AnalysesApi
  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_path '/analyses/addresses/contains' do
      operation :post do
        key :description, '指定した緯度経度を包含している住所コード毎の件数を取得します。'
        key :tags, ['Analysis']
        parameter name: :datas do
          key :in, :body
          key :description, '緯度経度の配列と住所レベル'
          key :required, true
          schema do
            key :type, :object
            property :coordinates do
              key :type, :array
              items do
                key :type, :array
                items do
                  key :type, :number
                  key :format, :float
                end
              end
            end
            property :level do
              key :type, :integer
              key :format, :int32
            end
          end
        end

        response 200 do
          key :description, '住所コード毎の件数'
          schema do
            key :type, :array
            items do
              key :required, [:address_code, :count]
              property :address_code do
                key :type, :string
                key :example, '13'
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
