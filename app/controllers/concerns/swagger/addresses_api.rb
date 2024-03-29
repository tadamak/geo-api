module Swagger::AddressesApi
  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_path '/addresses' do
      operation :get do
        key :description, '住所情報を取得します。'
        key :tags, ['Address']
        security do
          key :api_key, []
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
        parameter name: :code do
          key :in, :query
          key :description, '住所コード。カンマ区切りで複数指定可能。'
          key :required, false
          key :type, :string
        end
        parameter name: :parent_code do
          key :in, :query
          key :description, '住所コード。指定したコード配下の住所情報を取得。'
          key :required, false
          key :type, :string
        end
        parameter name: :location do
          key :in, :query
          key :description, '検索基点。カンマ区切りで"緯度,経度"の順で指定。'
          key :required, false
          key :type, :string
          key :example, '35.689568,139.691717'
        end
        parameter name: :radius do
          key :in, :query
          key :description, "検索範囲の半径(m)。location 指定時のみ有効。最大値は#{Constants::MAX_RADIUS}。"
          key :required, false
          key :type, :integer
          key :default, Constants::DEFAULT_RADIUS
          key :maximum, Constants::MAX_RADIUS
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
          key :description, '取得開始位置'
          key :required, false
          key :type, :integer
          key :default, 0
        end
        parameter name: :sort do
          key :in, :query
          key :description, "並び順。'code', 'kana', 'level', 'area', 'distance' が選択可。'distance' は location 指定時のみ有効。"
          key :required, false
          key :type, :string
          key :default, 'code'
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
          key :api_key, []
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

    swagger_path '/addresses/shape' do
      operation :get do
        key :description, '住所ポリゴンを取得します。'
        key :tags, ['Address']
        security do
          key :api_key, []
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
        parameter name: :code do
          key :in, :query
          key :description, '住所コード。カンマ区切りで複数指定可能。'
          key :required, false
          key :type, :string
        end
        parameter name: :parent_code do
          key :in, :query
          key :description, '住所コード。指定したコード配下の住所情報を取得。'
          key :required, false
          key :type, :string
        end
        parameter name: :location do
          key :in, :query
          key :description, '検索基点。カンマ区切りで"緯度,経度"の順で指定。'
          key :required, false
          key :type, :string
          key :example, '35.689568,139.691717'
        end
        parameter name: :radius do
          key :in, :query
          key :description, "検索範囲の半径(m)。location 指定時のみ有効。最大値は#{Constants::MAX_RADIUS}。"
          key :required, false
          key :type, :integer
          key :default, Constants::DEFAULT_RADIUS
          key :maximum, Constants::MAX_RADIUS
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
          key :description, '取得開始位置'
          key :required, false
          key :type, :integer
          key :default, 0
        end
        parameter name: :sort do
          key :in, :query
          key :description, "並び順。'code', 'kana', 'level', 'area', 'distance' が選択可。'distance' は location 指定時のみ有効。"
          key :required, false
          key :type, :string
          key :default, 'code'
        end
        parameter name: :merged do
          key :in, :query
          key :description, 'ポリゴンをマージするか否か。真: FeatureCollection, 偽: Feature の Array。'
          key :required, false
          key :type, :boolean
          key :default, true
        end

        response 200 do
          key :description, '住所ポリゴン'
          schema do
            key :'$ref', :GeoJson
          end
          header 'X-Total-Count' do
            key :description, 'リクエストに対する総件数'
            key :type, :integer
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
          key :api_key, []
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
          key :api_key, []
        end
        parameter name: :location do
          key :in, :query
          key :description, '緯度経度。カンマ区切りで"緯度,経度"の順で指定。'
          key :required, true
          key :type, :string
          key :example, '35.689568,139.691717'
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
