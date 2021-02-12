class V1::Statistics::AddressesController < ApplicationController
  include Swagger::StatisticsApi

  before_action :validate_populations_params, only: [:populations]

  def populations
    population = AddressPopulation.select("
      SUM(male_age_0_4) as male_age_0_4,
      SUM(male_age_5_9) as male_age_5_9,
      SUM(male_age_10_14) as male_age_10_14,
      SUM(male_age_15_19) as male_age_15_19,
      SUM(male_age_20_24) as male_age_20_24,
      SUM(male_age_25_29) as male_age_25_29,
      SUM(male_age_30_34) as male_age_30_34,
      SUM(male_age_35_39) as male_age_35_39,
      SUM(male_age_40_44) as male_age_40_44,
      SUM(male_age_45_49) as male_age_45_49,
      SUM(male_age_50_54) as male_age_50_54,
      SUM(male_age_55_59) as male_age_55_59,
      SUM(male_age_60_64) as male_age_60_64,
      SUM(male_age_65_69) as male_age_65_69,
      SUM(male_age_70_74) as male_age_70_74,
      SUM(male_age_75) as male_age_75,
      SUM(female_age_0_4) as female_age_0_4,
      SUM(female_age_5_9) as female_age_5_9,
      SUM(female_age_10_14) as female_age_10_14,
      SUM(female_age_15_19) as female_age_15_19,
      SUM(female_age_20_24) as female_age_20_24,
      SUM(female_age_25_29) as female_age_25_29,
      SUM(female_age_30_34) as female_age_30_34,
      SUM(female_age_35_39) as female_age_35_39,
      SUM(female_age_40_44) as female_age_40_44,
      SUM(female_age_45_49) as female_age_45_49,
      SUM(female_age_50_54) as female_age_50_54,
      SUM(female_age_55_59) as female_age_55_59,
      SUM(female_age_60_64) as female_age_60_64,
      SUM(female_age_65_69) as female_age_65_69,
      SUM(female_age_70_74) as female_age_70_74,
      SUM(female_age_75) as female_age_75"
    ).where('address_code LIKE ?', "#{@address.code}%").first

    render json: {
      male: {
        age_0_4: population[:male_age_0_4],
        age_5_9: population[:male_age_5_9],
        age_10_14: population[:male_age_10_14],
        age_15_19: population[:male_age_15_19],
        age_20_24: population[:male_age_20_24],
        age_25_29: population[:male_age_25_29],
        age_30_34: population[:male_age_30_34],
        age_35_39: population[:male_age_35_39],
        age_40_44: population[:male_age_40_44],
        age_45_49: population[:male_age_45_49],
        age_50_54: population[:male_age_50_54],
        age_55_59: population[:male_age_55_59],
        age_60_64: population[:male_age_60_64],
        age_65_69: population[:male_age_65_69],
        age_70_74: population[:male_age_70_74],
        age_75: population[:male_age_75],
      },
      female: {
        age_0_4: population[:female_age_0_4],
        age_5_9: population[:female_age_5_9],
        age_10_14: population[:female_age_10_14],
        age_15_19: population[:female_age_15_19],
        age_20_24: population[:female_age_20_24],
        age_25_29: population[:female_age_25_29],
        age_30_34: population[:female_age_30_34],
        age_35_39: population[:female_age_35_39],
        age_40_44: population[:female_age_40_44],
        age_45_49: population[:female_age_45_49],
        age_50_54: population[:female_age_50_54],
        age_55_59: population[:female_age_55_59],
        age_60_64: population[:female_age_60_64],
        age_65_69: population[:female_age_65_69],
        age_70_74: population[:female_age_70_74],
        age_75: population[:female_age_75],
      }
    }
  end

  private

  def validate_populations_params
    address_code = params[:address_code]
    @address = Address.find_by(code: address_code)
    if address_code.blank?
      return render_400(ErrorCode::REQUIRED_PARAM, 'address_code の指定が必要です。')
    elsif @address.nil?
      return render_400(ErrorCode::INVALID_PARAM, '存在しない address_code を指定しています。')
    end
  end
end
