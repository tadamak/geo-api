class GeoAddress < ApplicationRecord
  def self.geojson(address_codes)
    results = self.select('address_code, ST_AsGeoJSON(polygon) as geojson').where(address_code: address_codes)
    features = []
    results.each do |result|
      geojson = result.attributes['geojson']
      features << {
        type: 'Feature',
        properties: {
          code: result.address_code
        },
        geometry: JSON.parse(geojson)
      }
    end
    return {
      type: 'FeatureCollection',
      features: features
    }
  end

  def self.count_by_address_code(coordinates, level)
    sql = ''
    coordinates.each do |c|
      sql += "UNION ALL\n" unless sql.empty?
      sql += "SELECT GeomFromText('POINT(#{c[0]} #{c[1]})', 4326) point\n"
    end

    geo_addresses = self.find_by_sql("
      SELECT geo_addresses.address_code, count(1) as count
      FROM (#{sql}) as t
      INNER JOIN geo_addresses
      ON ST_Contains(geo_addresses.polygon, t.point) = 1
      WHERE geo_addresses.level = #{level}
      GROUP BY geo_addresses.address_code;")

    count_by_address_codes = []
    geo_addresses.each do |geo_address|
      count_by_address_codes << {
        address_code: geo_address.address_code,
        count: geo_address.attributes['count']
      }
    end
    count_by_address_codes
  end
end
