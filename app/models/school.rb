class School < ApplicationRecord
  include Swagger::SchoolSchema

  attr_accessor :is_embed_address, :is_embed_school_district

  enum school_type: { elementary_school: 1, junior_high_school: 2, secondary_school: 3, high_school: 4, technical_college: 5, junior_college: 6, university: 7, special_education_school: 8 }
  enum school_admin: { national: 1, prefecture: 2, area: 3, non_government: 4, other: 0 }

  belongs_to :address, class_name: 'Address', primary_key: :code, foreign_key: :address_code
  has_one :school_district, class_name: 'SchoolDistrict', primary_key: :code, foreign_key: :school_code

  def location
    {
      lat: latitude,
      lng: longitude
    }
  end
end
