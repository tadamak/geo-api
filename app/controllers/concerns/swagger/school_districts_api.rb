module Swagger::SchoolDistrictsApi
  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_path '/school_districts' do
      operation :get do
        key :description, '指定した住所コードの学区情報を取得します。'
        key :tags, ['School']
        security do
          key :access_token, []
        end
        parameter name: :address_code do
          key :in, :query
          key :description, '住所コード。レベル2(市区町村)のみ指定可能。'
          key :required, true
          key :type, :string
        end
        parameter name: :school_type do
          key :in, :query
          key :description, '学校種別。"1" (小学校)または "2" (中学校)を指定可能。'
          key :required, false
          key :type, :integer
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

    swagger_path '/school_districts/{id}' do
      operation :get do
        key :description, '指定したIDの学区情報を取得します。'
        key :tags, ['School']
        security do
          key :access_token, []
        end
        parameter name: :id do
          key :in, :path
          key :description, '学区ID'
          key :required, true
          key :type, :string
        end

        response 200 do
          key :description, '学区情報'
          schema do
            key :'$ref', :SchoolDistrict
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

    swagger_path '/school_districts/shape' do
      operation :get do
        key :description, '指定した住所コードの学区ポリゴンを取得します。'
        key :tags, ['School']
        security do
          key :access_token, []
        end
        parameter name: :address_code do
          key :in, :query
          key :description, '住所コード。レベル2(市区町村)のみ指定可能。'
          key :required, true
          key :type, :string
        end
        parameter name: :school_type do
          key :in, :query
          key :description, '学校種別。"1" (小学校)または "2" (中学校)を指定可能。'
          key :required, false
          key :type, :integer
        end

        response 200 do
          key :description, '学区ポリゴン'
          schema do
            key :'$ref', :GeoJson
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

    swagger_path '/school_districts/{id}/shape' do
      operation :get do
        key :description, '指定したIDの学区ポリゴンを取得します。'
        key :tags, ['School']
        security do
          key :access_token, []
        end
        parameter name: :id do
          key :in, :path
          key :description, '学区ID'
          key :required, true
          key :type, :string
        end

        response 200 do
          key :description, '学区ポリゴン'
          schema do
            key :'$ref', :GeoJson
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
