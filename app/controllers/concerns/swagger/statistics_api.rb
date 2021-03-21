module Swagger::StatisticsApi
  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_path '/statistics/addresses/populations' do
      operation :get do
        key :description, '指定した住所コードの性別・年齢毎の人口を取得します。'
        key :tags, ['Statistics']
        security do
          key :access_token, []
        end
        parameter name: :address_level do
          key :in, :query
          key :description, '住所レベル'
          key :required, false
          key :type, :integer
        end
        parameter name: :address_code do
          key :in, :query
          key :description, '住所コード。カンマ区切りで複数指定可能。'
          key :required, false
          key :type, :string
        end
        parameter name: :parent_address_code do
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
          key :description, '取得開始位置'
          key :required, false
          key :type, :integer
          key :default, 0
        end
        parameter name: :sort do
          key :in, :query
          key :description, "並び順。'address_code', 'address_level', 'total' が選択可。"
          key :required, false
          key :type, :string
          key :default, 'address_code'
        end

        response 200 do
          key :description, '住所コードの人口'
          schema do
            key :type, :array
            items do
              key :'$ref', :AddressPopulation
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

    swagger_path '/statistics/meshes/populations' do
      operation :get do
        key :deprecated, true
        key :description, '指定したメッシュコードの性別・年齢毎の人口を取得します。'
        key :tags, ['Statistics']
        security do
          key :access_token, []
        end
        parameter name: :address_code do
          key :in, :query
          key :description, 'メッシュコード。10桁(4分の1地域メッシュ)まで指定可能。カンマ区切りで複数指定可能。'
          key :required, false
          key :type, :string
        end

        response 200 do
          key :description, '指定したコードの人口。複数指定時は合算値。'
          schema do
            key :required, [:male, :female]
            property :male do
              property :age_0_14 do
                key :type, :integer
                key :description, '男性0~14歳'
                key :example, 100
              end
              property :age_15_64 do
                key :type, :integer
                key :description, '男性15~64歳'
                key :example, 100
              end
              property :age_65 do
                key :type, :integer
                key :description, '男性65歳以上'
                key :example, 100
              end
            end
            property :female do
              property :age_0_14 do
                key :type, :integer
                key :description, '女性0~14歳'
                key :example, 100
              end
              property :age_15_64 do
                key :type, :integer
                key :description, '女性15~64歳'
                key :example, 100
              end
              property :age_65 do
                key :type, :integer
                key :description, '女性65歳以上'
                key :example, 100
              end
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
