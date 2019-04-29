module Swagger::AddressesApi
  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_path '/addresses/{code}' do
      operation :get do
        key :description, '指定した住所コードの住所情報を取得します。'
        key :tags, ['Address']
        parameter name: :code do
          key :in, :path
          key :description, '住所コード'
          key :required, true
          key :type, :string
        end

        response 200 do
          key :description, '住所情報'
          schema do
            key :'$ref', :Address
          end
        end
      end
    end

    swagger_path '/addresses/search' do
      operation :get do
        key :description, '指定した条件に合致する住所情報をリストで取得します。'
        key :tags, ['Address']
        parameter name: :code do
          key :in, :query
          key :description, '住所コード<br>指定したコードの１階層下の住所情報を取得します。'
          key :required, false
          key :type, :string
        end
        parameter name: :limit do
          key :in, :query
          key :description, '取得件数<br>Default:10'
          key :required, false
          key :type, :integer
        end
        parameter name: :offset do
          key :in, :query
          key :description, '取得開始位置<br>Default:0'
          key :required, false
          key :type, :integer
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
      end
    end

    swagger_path '/addresses/shapes/{code}' do
      operation :get do
        key :description, '指定した住所コードのポリゴンを取得します。'
        key :tags, ['Address']
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
      end
    end
  end
end
