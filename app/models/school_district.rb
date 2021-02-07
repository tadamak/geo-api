class SchoolDistrict < ApplicationRecord
  include Swagger::SchoolDistrictSchema

  enum school_type: { elementary_school: 1, junior_high_school: 2 }

  # 絞り込み条件
  FILTER = {
    CONTAIN: 'contain',
    PARTIAL: 'partial',
    TOUCH: 'touch'
  }

  belongs_to :school, class_name: 'School', primary_key: :code, foreign_key: :school_code
  belongs_to :address, class_name: 'Address', primary_key: :code, foreign_key: :address_code

  def location
    {
      lat: latitude,
      lng: longitude
    }
  end

  def self.geojsons
    results = self.select('code, address_code, school_code, school_type, school_name, ST_AsGeoJSON(polygon) as geojson')
    geojsons = []
    results.each do |result|
      geojsons << {
        type: 'Feature',
        properties: {
          code: result.code,
          address_code: result.address_code,
          school_code: result.school_code,
          school_type: result.school_type_before_type_cast,
          school_name: result.school_name,
        },
        geometry: JSON.parse(result.attributes['geojson'])
      }
    end
    return geojsons
  end
end
