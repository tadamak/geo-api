module Swagger::SchoolDistrictsApi
  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_path '/school_districts' do
      operation :get do
        key :description, '指定した住所コードの学区情報を取得します。'
        key :tags, ['School District']
        security do
          key :access_token, []
        end
        parameter name: :name do
          key :in, :query
          key :description, '学校名称'
          key :required, false
          key :type, :string
        end
        parameter name: :address_code do
          key :in, :query
          key :description, '住所コード。レベル2(市区町村)のみ指定可能。'
          key :required, false
          key :type, :string
        end
        parameter name: :school_type do
          key :in, :query
          key :description, '学校種別。"1" (小学校)または "2" (中学校)を指定可能。'
          key :required, false
          key :type, :integer
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
          key :description, "並び順。'code', 'school_name', 'address_code', 'distance' が選択可。'distance' は location 指定時のみ有効。"
          key :required, false
          key :type, :string
          key :default, 'code'
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

    swagger_path '/school_districts/{code}' do
      operation :get do
        key :description, '指定したコードの学区情報を取得します。'
        key :tags, ['School District']
        security do
          key :access_token, []
        end
        parameter name: :code do
          key :in, :path
          key :description, '学区コード'
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
        key :tags, ['School District']
        security do
          key :access_token, []
        end
        parameter name: :name do
          key :in, :query
          key :description, '学校名称'
          key :required, false
          key :type, :string
        end
        parameter name: :address_code do
          key :in, :query
          key :description, '住所コード。レベル2(市区町村)のみ指定可能。'
          key :required, false
          key :type, :string
        end
        parameter name: :school_type do
          key :in, :query
          key :description, '学校種別。"1" (小学校)または "2" (中学校)を指定可能。'
          key :required, false
          key :type, :integer
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
          key :description, "並び順。'code', 'school_name', 'address_code', 'distance' が選択可。'distance' は location 指定時のみ有効。"
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

    swagger_path '/school_districts/{code}/shape' do
      operation :get do
        key :description, '指定したコードの学区ポリゴンを取得します。'
        key :tags, ['School District']
        security do
          key :access_token, []
        end
        parameter name: :code do
          key :in, :path
          key :description, '学区コード'
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

    swagger_path '/school_districts/{code}/addresses' do
      operation :get do
        key :description, '指定したコードの学区に含まれる住所(町丁・字等)を取得します。'
        key :tags, ['School District']
        security do
          key :access_token, []
        end
        parameter name: :code do
          key :in, :path
          key :description, '学区コード'
          key :required, true
          key :type, :string
        end
        parameter name: :filter do
          key :in, :query
          key :description, '絞り込み条件。"contain" (完全に含まれる住所のみ)または "partial" (部分的に含まれる住所のみ)を指定可能。未指定時は全て取得。'
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
        parameter name: :sort do
          key :in, :query
          key :description, "並び順。'code', 'name' が選択可。"
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

    swagger_path '/school_districts/{code}/school_districts' do
      operation :get do
        key :description, '指定したコードの学区に含まれる学区情報を取得します。'
        key :tags, ['School District']
        security do
          key :access_token, []
        end
        parameter name: :code do
          key :in, :path
          key :description, '学区コード'
          key :required, true
          key :type, :string
        end
        parameter name: :school_type do
          key :in, :query
          key :description, '学校種別。"1" (小学校)または "2" (中学校)を指定可能。'
          key :required, false
          key :type, :integer
        end
        parameter name: :filter do
          key :in, :query
          key :description, '絞り込み条件。"contain" (完全に含まれる学区のみ), "partial" (部分的に含まれる学区のみ), "touch" (隣接している学区のみ) のいずれかを指定可能。未指定時は含まれる全ての学区を取得。'
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
        parameter name: :sort do
          key :in, :query
          key :description, "並び順。'code', 'school_name', 'address_code' が選択可。"
          key :required, false
          key :type, :string
          key :default, 'code'
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
  end
end
