module Swagger::AddressesApi
  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_path '/addresses' do
      operation :get do
        key :description, '住所情報を取得します。'
        key :tags, ['Address']
        security do
          key :access_token, []
        end
        parameter name: :name do
          key :in, :query
          key :description, '住所名称'
          key :required, false
          key :type, :string
        end
        parameter name: :level do
          key :in, :query
          key :description, '住所レベル'
          key :required, false
          key :type, :integer
        end
        parameter name: :codes do
          key :in, :query
          key :description, '住所コード。カンマ区切りで複数指定可能。(ex. codes=13,13101)'
          key :required, false
          key :type, :string
        end
        parameter name: :parent_code do
          key :in, :query
          key :description, '住所コード。指定したコード配下の住所情報を取得。'
          key :required, false
          key :type, :string
        end
        parameter name: :limit do
          key :in, :query
          key :description, "取得件数。最大値は#{Constants::MAX_LIMIT}。"
          key :required, false
          key :type, :integer
          key :default, Constants::DEFAULT_LIMIT
          key :maximum, Constants::MAX_LIMIT
        end
        parameter name: :offset do
          key :in, :query
          key :description, '取得開始位置。'
          key :required, false
          key :type, :integer
          key :default, 0
        end

        response 200 do
          key :description, '住所情報'
          schema do
            key :type, :array
            items do
              key :'$ref', :Address
            end
          end
          header 'X-Total-Count' do
            key :description, 'リクエストに対する総件数'
            key :type, :integer
            key :format, :int64
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

    swagger_path '/addresses/{code}' do
      operation :get do
        key :description, '指定したコードの住所情報を取得します。'
        key :tags, ['Address']
        security do
          key :access_token, []
        end
        parameter name: :code do
          key :in, :path
          key :description, '住所コード'
          key :required, true
          key :type, :string
        end

        response 200 do
          key :description, '住所情報'
          schema do
            key :'$ref', :Station
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

    swagger_path '/addresses/shapes' do
      operation :get do
        key :description, '住所ポリゴンを取得します。'
        key :tags, ['Address']
        security do
          key :access_token, []
        end
        parameter name: :codes do
          key :in, :query
          key :description, '住所コード。カンマ区切りで複数指定可能。(ex. codes=13101,13102)'
          key :required, true
          key :type, :string
        end
        parameter name: :limit do
          key :in, :query
          key :description, "取得件数。最大値は#{Constants::MAX_LIMIT}。"
          key :required, false
          key :type, :integer
          key :default, Constants::DEFAULT_LIMIT
          key :maximum, Constants::MAX_LIMIT
        end
        parameter name: :offset do
          key :in, :query
          key :description, '取得開始位置。'
          key :required, false
          key :type, :integer
          key :default, 0
        end

        response 200 do
          key :description, '住所ポリゴン'
          schema do
            key :type, :array
            items do
              key :'$ref', :GeoJson
            end
          end
          header 'X-Total-Count' do
            key :description, 'リクエストに対する総件数'
            key :type, :integer
            key :format, :int64
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

    swagger_path '/addresses/{code}/shape' do
      operation :get do
        key :description, '指定したコードの住所ポリゴンを取得します。'
        key :tags, ['Address']
        security do
          key :access_token, []
        end
        parameter name: :code do
          key :in, :path
          key :description, '住所コード'
          key :required, true
          key :type, :string
        end

        response 200 do
          key :description, '住所ポリゴン'
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

    swagger_path '/addresses/geocoding' do
      operation :get do
        key :description, '指定した緯度経度を元に逆ジオコーディングした結果の住所情報を取得します。'
        key :tags, ['Address']
        security do
          key :access_token, []
        end
        parameter name: :location do
          key :in, :query
          key :description, '緯度経度。カンマ区切りで"緯度,経度"の順で指定。(ex. location=35.689568,139.691717)'
          key :required, true
          key :type, :string
        end

        response 200 do
          key :description, '住所情報'
          schema do
            key :'$ref', :Address
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
