module Swagger::MeshesApi
  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_path '/meshes' do
      operation :get do
        key :description, '指定したコードの地域メッシュ情報を取得します。'
        key :tags, ['Mesh']
        parameter name: :codes do
          key :in, :query
          key :description, '地域メッシュコード。カンマ区切りで複数指定可能。(ex. codes=30365090,30365091)'
          key :required, true
          key :type, :string
        end

        response 200 do
          key :description, '地域メッシュ情報'
          schema do
            key :type, :array
            items do
              key :'$ref', :Mesh
            end
          end
        end

        response 400 do
          schema do
            property :error do
              key :'$ref', :Error
            end
          end
        end
      end
    end

    swagger_path '/meshes/search' do
      operation :get do
        key :description, '指定した条件に合致する地域メッシュ情報をリストで取得します。'
        key :tags, ['Mesh']
        parameter name: :code do
          key :in, :query
          key :description, '地域メッシュコード。指定したコードの１階層下の地域メッシュ情報を取得します。'
          key :required, true
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
          key :description, '取得開始位置。'
          key :required, false
          key :type, :integer
          key :default, 0
        end

        response 200 do
          key :description, '地域メッシュ情報'
          schema do
            key :type, :array
            items do
              key :'$ref', :Mesh
            end
          end
          header 'X-Total-Count' do
            key :description, 'リクエストに対する総件数'
            key :type, :integer
            key :format, :int64
          end
        end

        response 400 do
          schema do
            property :error do
              key :'$ref', :Error
            end
          end
        end
      end
    end

    swagger_path '/meshes/shapes' do
      operation :get do
        key :description, '指定した地域メッシュコードのポリゴンを取得します。'
        key :tags, ['Mesh']
        parameter name: :codes do
          key :in, :query
          key :description, '地域メッシュコード。カンマ区切りで複数指定可能。(ex. codes=30365090,30365091)'
          key :required, true
          key :type, :string
        end

        response 200 do
          key :description, '地域メッシュポリゴン'
          schema do
            key :type, :array
            items do
              key :'$ref', :GeoJson
            end
          end
        end

        response 400 do
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
