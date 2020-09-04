module Swagger::SchoolDistrictsApi
  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_path '/school_districts' do
      operation :get do
        key :description, '指定したコードの学区情報を取得します。'
        key :tags, ['School']
        security do
          key :access_token, []
        end
        parameter name: :address_codes do
          key :in, :query
          key :description, '住所コード。カンマ区切りで複数指定可能。(ex. codes=13,13101)'
          key :required, true
          key :type, :string
        end

        response 200 do
          key :description, '学区情報'
          schema do
            key :type, :array
            items do
              key :'$ref', :SchoolDistrict
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

    swagger_path '/school_districts/shapes' do
      operation :get do
        key :description, '指定した住所コードの学区ポリゴンを取得します。'
        key :tags, ['School']
        security do
          key :access_token, []
        end
        parameter name: :address_codes do
          key :in, :query
          key :description, '住所コード。カンマ区切りで複数指定可能。(ex. codes=13101,13102)'
          key :required, true
          key :type, :string
        end

        response 200 do
          key :description, '学区ポリゴン'
          schema do
            key :type, :array
            items do
              key :'$ref', :GeoJson
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
