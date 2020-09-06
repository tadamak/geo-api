module Swagger::SchoolDistrictSchema
  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_schema :SchoolDistrict do
      key :required, [:id, :address_code, :school_type, :school_name, :school_address, :location]
      property :id do
        key :type, :integer
        key :example, 6389
      end
      property :address_code do
        key :type, :string
        key :example, '13101'
      end
      property :school_type do
        key :type, :integer
        key :example, 1
      end
      property :school_name do
        key :type, :string
        key :example, '千代田区立お茶の水小学校'
      end
      property :school_address do
        key :type, :string
        key :example, '千代田区猿楽町1-1-1'
      end
      property :location do
        key :type, :object
        property :lat do
          key :type, :number
          key :format, :float
          key :example, 35.68151
        end
        property :lng do
          key :type, :number
          key :format, :float
          key :example, 139.76699
        end
      end
    end
  end
end
