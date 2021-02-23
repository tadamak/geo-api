module Swagger::StatisticsApi
  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_path '/statistics/addresses/population' do
      operation :get do
        key :description, '指定した住所コードの性別・年齢毎の人口を取得します。'
        key :tags, ['Statistics']
        security do
          key :access_token, []
        end
        parameter name: :address_code do
          key :in, :query
          key :description, '住所コード。カンマ区切りで複数指定可能。'
          key :required, false
          key :type, :string
        end

        response 200 do
          key :description, '指定したコードの人口。複数指定時は合算値。'
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

    swagger_path '/statistics/meshes/population' do
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
