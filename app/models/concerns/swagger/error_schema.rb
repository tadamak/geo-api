module Swagger::ErrorSchema
  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_schema :Error do
      key :required, [:code, :type, :message]
      property :code do
        key :type, :integer
        key :example, 1001
        key :description, 'エラーコード'
      end
      property :type do
        key :type, :string
        key :example, 'invalid_param'
        key :description, 'エラー種別'
      end
      property :message do
        key :type, :string
        key :example, '無効なパラメータです。'
        key :description, 'エラーメッセージ'
      end
    end
  end
end
