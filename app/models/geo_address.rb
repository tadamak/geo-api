class GeoAddress < ApplicationRecord
  def self.geojson(address_code)
    geojson = self.find_by_sql("SELECT ST_AsGeoJSON(polygon) as geojson from geo_addresses where address_code = #{address_code} LIMIT 1").first.attributes['geojson']
    return {
      type: 'Feature',
      geomety: JSON.parse(geojson)
    }
  end
end
