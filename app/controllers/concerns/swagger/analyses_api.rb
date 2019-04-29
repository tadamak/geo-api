module Swagger::AnalysesApi
  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_path '/analyses/addresses/contains' do
      operation :get do
        key :description, '住所検索'
        key :tags, ['Analysis']
        parameter name: :coordinates do
          key :in, :query
          key :description, '緯度経度の配列'
          key :required, true
          key :type, :string
        end
        parameter name: :level do
          key :in, :query
          key :description, '住所レベル'
          key :required, true
          key :type, :integer
        end

        response 200 do
          key :description, 'TODO レスポンス'
        end
      end
    end

    swagger_path '/analyses/addresses/contains' do
      operation :post do
        key :description, '住所検索'
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
          key :description, 'TODO レスポンス'
        end
      end
    end
  end
end
