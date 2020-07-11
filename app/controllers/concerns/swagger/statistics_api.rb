module Swagger::StatisticsApi
  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_path '/statistics/addresses/population' do
      operation :get do
        key :description, '指定した住所コードの人口・世帯数情報を取得します。'
        key :tags, ['Statistics']
        parameter name: :address_codes do
          key :in, :query
          key :description, '住所コード。カンマ区切りで複数指定可能。(ex. address_codes=13101,13102)'
          key :required, true
          key :type, :string
        end
        response 200 do
          key :description, '住所コード毎の件数'
          schema do
            key :type, :array
            items do
              key :required, [:address_code, :count]
              property :address_code do
                key :type, :string
                key :example, '13101'
              end
              property :count do
                key :type, :object
                key :required, [:population, :households]
                property :population do
                  key :type, :integer
                  key :description, '人口'
                  key :format, :int32
                  key :example, 36000
                end
                property :households do
                  key :type, :integer
                  key :description, '世帯数'
                  key :format, :int32
                  key :example, 12000
                end
              end
            end
          end
        end
      end
    end
  end
end