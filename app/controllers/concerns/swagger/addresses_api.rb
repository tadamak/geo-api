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
        parameter name: :word do
          key :in, :query
          key :description, '住所名称。指定したワードが含まれる住所情報を取得します。codeとの併用は不可（どちらか片方を必ず指定）。'
          key :required, true
          key :type, :string
        end
        parameter name: :code do
          key :in, :query
          key :description, '住所コード。指定したコードの１階層下の住所情報を取得します。wordとの併用は不可（どちらか片方を必ず指定）。'
          key :required, true
          key :type, :string
        end
        parameter name: :limit do
          key :in, :query
          key :description, '取得件数。最大値は100。'
          key :required, false
          key :type, :integer
          key :default, 10
          key :maximum, 100
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
