module Swagger::AddressesApi
  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_path '/addresses/{code}' do
      operation :get do
        key :description, '住所コードから住所情報を取得する'
        key :tags, ['address']
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
  end
end