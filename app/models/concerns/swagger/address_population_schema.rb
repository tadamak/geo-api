module Swagger::AddressPopulationSchema
  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_schema :AddressPopulation do
      key :required, [:address_code, :address_level, :total, :male, :female]
      property :address_code do
        key :type, :string
        key :description, '住所コード'
        key :example, '13'
      end

      property :address_level do
        key :type, :integer
        key :example, 1
        key :description, '住所レベル'
      end

      property :total do
        key :type, :integer
        key :example, 3200
        key :description, '総人口'
      end

      property :male do
        property :age_0_4 do
          key :type, :integer
          key :description, '男性0~4歳'
          key :example, 100
        end
        property :age_5_9 do
          key :type, :integer
          key :description, '男性5~9歳'
          key :example, 100
        end
        property :age_10_14 do
          key :type, :integer
          key :description, '男性10~14歳'
          key :example, 100
        end
        property :age_15_19 do
          key :type, :integer
          key :description, '男性15~19歳'
          key :example, 100
        end
        property :age_20_24 do
          key :type, :integer
          key :description, '男性20~24歳'
          key :example, 100
        end
        property :age_25_29 do
          key :type, :integer
          key :description, '男性25~29歳'
          key :example, 100
        end
        property :age_30_34 do
          key :type, :integer
          key :description, '男性30~34歳'
          key :example, 100
        end
        property :age_35_39 do
          key :type, :integer
          key :description, '男性35~39歳'
          key :example, 100
        end
        property :age_40_44 do
          key :type, :integer
          key :description, '男性40~44歳'
          key :example, 100
        end
        property :age_45_49 do
          key :type, :integer
          key :description, '男性45~49歳'
          key :example, 100
        end
        property :age_50_54 do
          key :type, :integer
          key :description, '男性50~54歳'
          key :example, 100
        end
        property :age_55_59 do
          key :type, :integer
          key :description, '男性55~59歳'
          key :example, 100
        end
        property :age_60_64 do
          key :type, :integer
          key :description, '男性60~64歳'
          key :example, 100
        end
        property :age_65_69 do
          key :type, :integer
          key :description, '男性65~69歳'
          key :example, 100
        end
        property :age_70_74 do
          key :type, :integer
          key :description, '男性70~74歳'
          key :example, 100
        end
        property :age_75 do
          key :type, :integer
          key :description, '男性75歳以上'
          key :example, 100
        end
      end
      property :female do
        property :age_0_4 do
          key :type, :integer
          key :description, '女性0~4歳'
          key :example, 100
        end
        property :age_5_9 do
          key :type, :integer
          key :description, '女性5~9歳'
          key :example, 100
        end
        property :age_10_14 do
          key :type, :integer
          key :description, '女性10~14歳'
          key :example, 100
        end
        property :age_15_19 do
          key :type, :integer
          key :description, '女性15~19歳'
          key :example, 100
        end
        property :age_20_24 do
          key :type, :integer
          key :description, '女性20~24歳'
          key :example, 100
        end
        property :age_25_29 do
          key :type, :integer
          key :description, '女性25~29歳'
          key :example, 100
        end
        property :age_30_34 do
          key :type, :integer
          key :description, '女性30~34歳'
          key :example, 100
        end
        property :age_35_39 do
          key :type, :integer
          key :description, '女性35~39歳'
          key :example, 100
        end
        property :age_40_44 do
          key :type, :integer
          key :description, '女性40~44歳'
          key :example, 100
        end
        property :age_45_49 do
          key :type, :integer
          key :description, '女性45~49歳'
          key :example, 100
        end
        property :age_50_54 do
          key :type, :integer
          key :description, '女性50~54歳'
          key :example, 100
        end
        property :age_55_59 do
          key :type, :integer
          key :description, '女性55~59歳'
          key :example, 100
        end
        property :age_60_64 do
          key :type, :integer
          key :description, '女性60~64歳'
          key :example, 100
        end
        property :age_65_69 do
          key :type, :integer
          key :description, '女性65~69歳'
          key :example, 100
        end
        property :age_70_74 do
          key :type, :integer
          key :description, '女性70~74歳'
          key :example, 100
        end
        property :age_75 do
          key :type, :integer
          key :description, '女性75歳以上'
          key :example, 100
        end
      end
    end
  end
end
