module Swagger::AddressesApi
  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_path '/addresses/search' do
      operation :get do
        key :description, '住所検索'
        key :tags, ['Address']
        parameter name: :code do
          key :in, :query
          key :description, '住所コード'
          key :required, false
          key :type, :string
        end
        parameter name: :limit do
          key :in, :query
          key :description, '取得件数'
          key :required, false
          key :type, :integer
        end
        parameter name: :offset do
          key :in, :query
          key :description, '取得開始位置'
          key :required, false
          key :type, :integer
        end

        response 200 do
          key :description, 'TODO レスポンス'
        end
      end
    end

    swagger_path '/addresses/{code}' do
      operation :get do
        key :description, '住所コードから住所情報を取得する'
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
            key :required, [:code, :name, :level, :coordinates]
            property :code do
              key :type, :string
            end
            property :name do
              key :type, :string
            end
            property :level do
              key :type, :integer
              key :format, :int32
            end
            property :coordinates do
              key :type, :object
              property :latitude do
                key :type, :number
                key :format, :float
              end
              property :longitude do
                key :type, :number
                key :format, :float
              end
            end
          end
        end
      end
    end

    swagger_path '/addresses/shapes/{code}' do
      operation :get do
        key :description, '住所コードから住所ポリゴンを取得する'
        key :tags, ['Address']
        parameter name: :code do
          key :in, :path
          key :description, '住所コード'
          key :required, true
          key :type, :string
        end

        response 200 do
          key :description, 'TODO レスポンス'
        end
      end
    end
  end
end
