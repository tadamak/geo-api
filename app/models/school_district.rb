class SchoolDistrict < ApplicationRecord
  include Swagger::SchoolDistrictSchema

  enum school_type: { elementary_school: 1, junior_high_school: 2 }

  def location
    return nil if latitude.nil? || longitude.nil?
    {
      lat: latitude,
      lng: longitude
    }
  end

  def self.geojson(address_codes, school_type = nil)
    results = self.select('address_code, school_type, school_name, ST_AsGeoJSON(polygon) as geojson').where(address_code: address_codes)
    results = results.where(school_type: school_type) unless school_type.nil?
    features = []
    results.each do |result|
      features << {
        type: 'Feature',
        properties: {
          address_code: result.address_code,
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
