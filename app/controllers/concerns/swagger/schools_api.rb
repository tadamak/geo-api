module Swagger::SchoolsApi
  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_path '/schools' do
      operation :get do
        key :description, '指定した住所コードの学校情報を取得します。'
        key :tags, ['School']
        security do
          key :access_token, []
        end
        parameter name: :name do
          key :in, :query
          key :description, '学校名'
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
          key :description, '学校種別 (1: 小学校, 2: 中学校, 3: 中等教育学校, 4: 高等学校, 5: 高等専門学校, 6: 短期大学, 7: 大学, 8: 特別支援学校)'
          key :required, false
          key :type, :integer
        end
        parameter name: :school_admin do
          key :in, :query
          key :description, '学校管理 (1: 国, 2: 都道府県, 3: 市区町村, 4: 民間, 0: その他)'
          key :required, false
          key :type, :integer
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
          key :description, "並び順。'code', 'name', 'address_code' が選択可。"
          key :required, false
          key :type, :string
          key :default, 'address_code'
        end

        response 200 do
          key :description, '学校情報'
          schema do
            key :type, :array
            items do
              key :'$ref', :School
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

    swagger_path '/schools/{code}' do
      operation :get do
        key :description, '指定したコードの学校情報を取得します。'
        key :tags, ['School']
        security do
          key :access_token, []
        end
        parameter name: :code do
          key :in, :path
          key :description, '学校コード'
          key :required, true
          key :type, :string
        end

        response 200 do
          key :description, '学校情報'
          schema do
            key :'$ref', :School
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
