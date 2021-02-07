module Swagger::RailwaysApi
  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_path '/railways/stations' do
      operation :get do
        key :description, '駅情報を取得します。'
        key :tags, ['Railway']
        security do
          key :access_token, []
        end
        parameter name: :address_code do
          key :in, :query
          key :description, '住所コード。'
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
          key :description, '駅情報'
          schema do
            key :type, :array
            items do
              key :'$ref', :Station
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

    swagger_path '/railways/stations/{code}' do
      operation :get do
        key :description, '指定したコードの駅情報を取得します。'
        key :tags, ['Railway']
        security do
          key :access_token, []
        end
        parameter name: :code do
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
