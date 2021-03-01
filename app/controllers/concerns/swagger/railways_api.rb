module Swagger::RailwaysApi
  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_path '/railways/stations' do
      operation :get do
        key :description, '駅情報を取得します。'
        key :tags, ['Railway']
        security do
          key :access_token, []
        end
        parameter name: :name do
          key :in, :query
          key :description, '駅名'
          key :required, false
          key :type, :string
        end
        parameter name: :address_code do
          key :in, :query
          key :description, '住所コード'
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
          key :description, "並び順。'code', 'name', 'address_code', 'distance' が選択可。'distance' は location 指定時のみ有効。"
          key :required, false
          key :type, :string
          key :default, 'code'
        end
        parameter name: :embed do
          key :in, :query
          key :description, "追加情報。'address' が選択可。"
          key :required, false
          key :type, :string
        end

        response 200 do
          key :description, '駅情報'
          schema do
            key :type, :array
            items do
              key :'$ref', :Station
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

    swagger_path '/railways/stations/{code}' do
      operation :get do
        key :description, '指定したコードの駅情報を取得します。'
        key :tags, ['Railway']
        security do
          key :access_token, []
        end
        parameter name: :code do
          key :in, :path
          key :description, '駅コード'
          key :required, true
          key :type, :string
        end
        parameter name: :embed do
          key :in, :query
          key :description, "追加情報。'address' が選択可。"
          key :required, false
          key :type, :string
        end

        response 200 do
          key :description, '駅情報'
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

    swagger_path '/railways/lines' do
      operation :get do
        key :deprecated, true
        key :description, '路線情報を取得します。'
        key :tags, ['Railway']
        security do
          key :access_token, []
        end
        parameter name: :name do
          key :in, :query
          key :description, '路線名称'
          key :required, false
          key :type, :string
        end
        parameter name: :code do
          key :in, :query
          key :description, '路線コード。カンマ区切りで複数指定可能。'
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
          key :description, '取得開始位置'
          key :required, false
          key :type, :integer
          key :default, 0
        end

        response 200 do
          key :description, '路線情報'
          schema do
            key :type, :array
            items do
              key :'$ref', :Station
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

    swagger_path '/railways/lines/{code}' do
      operation :get do
        key :deprecated, true
        key :description, '指定したコードの路線情報を取得します。'
        key :tags, ['Railway']
        security do
          key :access_token, []
        end
        parameter name: :code do
          key :in, :path
          key :description, '路線コード'
          key :required, true
          key :type, :string
        end

        response 200 do
          key :description, '路線情報'
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

    swagger_path '/railways/lines/shape' do
      operation :get do
        key :deprecated, true
        key :description, '路線ポリゴンを取得します。'
        key :tags, ['Railway']
        security do
          key :access_token, []
        end
        parameter name: :name do
          key :in, :query
          key :description, '路線名称'
          key :required, false
          key :type, :string
        end
        parameter name: :code do
          key :in, :query
          key :description, '路線コード。カンマ区切りで複数指定可能。'
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
          key :description, '取得開始位置'
          key :required, false
          key :type, :integer
          key :default, 0
        end

        response 200 do
          key :description, '路線ポリゴン'
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

    swagger_path '/railways/lines/{code}/shape' do
      operation :get do
        key :deprecated, true
        key :description, '指定したコードの路線ポリゴンを取得します。'
        key :tags, ['Railway']
        security do
          key :access_token, []
        end
        parameter name: :code do
          key :in, :path
          key :description, '路線コード'
          key :required, true
          key :type, :string
        end

        response 200 do
          key :description, '路線ポリゴン'
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
