module Swagger::RailwaysApi
  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_path '/railways/lines' do
      operation :get do
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
        parameter name: :line_codes do
          key :in, :query
          key :description, '路線コード。カンマ区切りで複数指定可能。(ex. line_codes=li-xn76kpcu1,st-xn76kpcu2)'
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

    swagger_path '/railways/lines/{line_code}' do
      operation :get do
        key :description, '指定したコードの路線情報を取得します。'
        key :tags, ['Railway']
        security do
          key :access_token, []
        end
        parameter name: :line_code do
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
        parameter name: :line_codes do
          key :in, :query
          key :description, '路線コード。カンマ区切りで複数指定可能。(ex. line_codes=li-xn76kpcu1,st-xn76kpcu2)'
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

    swagger_path '/railways/lines/{line_code}/shape' do
      operation :get do
        key :description, '指定したコードの路線ポリゴンを取得します。'
        key :tags, ['Railway']
        security do
          key :access_token, []
        end
        parameter name: :line_code do
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

    swagger_path '/railways/stations/{station_code}' do
      operation :get do
        key :description, '指定したコードの駅情報を取得します。'
        key :tags, ['Railway']
        security do
          key :access_token, []
        end
        parameter name: :station_code do
          key :in, :path
          key :description, '駅コード'
          key :required, true
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
  end
end
