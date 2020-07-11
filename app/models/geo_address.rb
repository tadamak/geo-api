class GeoAddress < ApplicationRecord

  def self.reverse_geocoding(lat, lng)
    self.where("ST_Contains(polygon, ST_GeomFromText('POINT(#{lng} #{lat})', 4326))").order(level: :desc).limit(1).first
  end

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

  def self.counts_by_address_code(locations, level)
    sql = ''
    locations.each do |l|
      lat = l.split(',')[0]
      lng = l.split(',')[1]
      sql += "UNION ALL\n" unless sql.empty?
      sql += "SELECT address_code FROM geo_addresses WHERE (ST_Contains(polygon, ST_GEOMFROMTEXT('POINT(#{lng} #{lat})', 4326))) AND level = #{level}\n"
    end

    geo_addresses = self.find_by_sql("
      SELECT t.address_code, count(*) as count
      FROM (#{sql}) as t
      GROUP BY t.address_code;")

    addresses = Address.where(code: geo_addresses.pluck(:address_code)).to_a

    counts_by_address_code = []
    geo_addresses.each do |geo_address|
      address = addresses.select{|a| a.code == geo_address.address_code}.first
      counts_by_address_code << {
        address: address,
        count: geo_address.attributes['count']
      }
    end
    counts_by_address_code
  end
end
