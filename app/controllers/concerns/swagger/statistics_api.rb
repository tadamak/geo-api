module Swagger::StatisticsApi
  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_path '/statistics/addresses/population' do
      operation :get do
        key :description, '指定した住所コードの性別・年齢毎の人口数を取得します。'
        key :tags, ['Statistics']
        security do
          key :access_token, []
        end
        parameter name: :address_code do
          key :in, :query
          key :description, '住所コード'
          key :required, false
          key :type, :string
        end

        response 200 do
          key :description, '住所コード毎の件数'
          schema do
            key :'$ref', :AddressPopulation
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
