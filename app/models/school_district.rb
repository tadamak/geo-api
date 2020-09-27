class SchoolDistrict < ApplicationRecord
  include Swagger::SchoolDistrictSchema

  enum school_type: { elementary_school: 1, junior_high_school: 2 }

  belongs_to :school, class_name: 'School', primary_key: :code, foreign_key: :school_code
  belongs_to :address, class_name: 'Address', primary_key: :code, foreign_key: :address_code

  def location
    return nil if latitude.nil? || longitude.nil?
    {
      lat: latitude,
      lng: longitude
    }
  end

  def self.geojson
    results = self.select('code, address_code, school_code, school_type, school_name, ST_AsGeoJSON(polygon) as geojson')
    features = []
    results.each do |result|
      features << {
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
    return {
      type: 'FeatureCollection',
      features: features
    }
  end
end