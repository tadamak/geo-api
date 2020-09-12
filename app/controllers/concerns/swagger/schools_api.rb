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
        parameter name: :address_code do
          key :in, :query
          key :description, '住所コード。レベル2(市区町村)のみ指定可能。'
          key :required, true
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
  end
end
