class School < ApplicationRecord
  include Swagger::SchoolSchema

  enum school_type: { elementary_school: 1, junior_high_school: 2, secondary_school: 3, high_school: 4, technical_college: 5, junior_college: 6, university: 7, special_education_school: 8 }
  enum school_admin: { national: 1, prefecture: 2, area: 3, non_government: 4, other: 0 }

  def location
    return nil if latitude.nil? || longitude.nil?
    {
      lat: latitude,
      lng: longitude
    }
  end
end
