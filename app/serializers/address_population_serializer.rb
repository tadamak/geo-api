class AddressPopulationSerializer < ActiveModel::Serializer
  attributes :male, :female

  def male
    {
      age_0_4: object.male_age_0_4,
      age_5_9: object.male_age_5_9,
      age_10_14: object.male_age_10_14,
      age_15_19: object.male_age_15_19,
      age_20_24: object.male_age_20_24,
      age_25_29: object.male_age_25_29,
      age_30_34: object.male_age_30_34,
      age_35_39: object.male_age_35_39,
      age_40_44: object.male_age_40_44,
      age_45_49: object.male_age_45_49,
      age_50_54: object.male_age_50_54,
      age_55_59: object.male_age_55_59,
      age_60_64: object.male_age_60_64,
      age_65_69: object.male_age_65_69,
      age_70_74: object.male_age_70_74,
      age_75: object.male_age_75,
    }
  end

  def female
    {
      age_0_4: object.female_age_0_4,
      age_5_9: object.female_age_5_9,
      age_10_14: object.female_age_10_14,
      age_15_19: object.female_age_15_19,
      age_20_24: object.female_age_20_24,
      age_25_29: object.female_age_25_29,
      age_30_34: object.female_age_30_34,
      age_35_39: object.female_age_35_39,
      age_40_44: object.female_age_40_44,
      age_45_49: object.female_age_45_49,
      age_50_54: object.female_age_50_54,
      age_55_59: object.female_age_55_59,
      age_60_64: object.female_age_60_64,
      age_65_69: object.female_age_65_69,
      age_70_74: object.female_age_70_74,
      age_75: object.female_age_75,
    }
  end
end
