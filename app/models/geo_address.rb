class GeoAddress < ApplicationRecord

  def self.reverse_geocoding(lat, lng)
    self.where("ST_Contains(polygon, ST_GeomFromText('POINT(#{lng} #{lat})', 4326))").order(level: :desc).limit(1).first
  end

  # 複数住所を1つのGeoJSONに変換する (GeoAddress:GeoJSON = N:1)
  def self.geojson(address_codes)
    results = self.select('address_code, ST_AsGeoJSON(polygon) as geojson').where(address_code: address_codes)
    features = []
    results.each do |result|
      features << {
        type: 'Feature',
        properties: {
          code: result.address_code
        },
        geometry: JSON.parse(result.attributes['geojson'])
      }
    end
    return {
      type: 'FeatureCollection',
      features: features
    }
  end

  # 住所単位にGeoJSONを生成する (GeoAddress:GeoJSON = 1:1)
  def self.geojsons(address_codes)
    results = self.select('address_code, ST_AsGeoJSON(polygon) as geojson').where(address_code: address_codes)
    geojsons = []
    results.each do |result|
      geojsons << {
        type: 'Feature',
        properties: {
          code: result.address_code
        },
        geometry: JSON.parse(result.attributes['geojson'])
      }
    end
    return geojsons
  end

  def self.counts_by_address_code(all_locations, level)
    each_slice_num = 1000
    slice_locations = all_locations.each_slice(each_slice_num).to_a
    results = Parallel.map(slice_locations) do |locations|
      points = locations.map { |l| "#{l[:lng]} #{l[:lat]}" }.join(',')
      ewkt = "SRID=4326;MULTIPOINT(#{points})"
      # NOTE: 都道府県のST_Containsが遅いため、最も下のレベル4(字・丁目)で解析をする
      sql = "
        SELECT address_code, count(*)
        FROM geo_addresses as t1, (SELECT geom(ST_Dump('#{ewkt}'::GEOMETRY))) as t2
        WHERE level = #{Address::LEVEL[:CHOME]} AND st_contains(t1.polygon, t2.geom)
        GROUP BY address_code;
      "
      self.find_by_sql(sql)
    end

    count = {}
    results.each do |result|
      result.each do |r|
        code = Address.code_by_level(r[:address_code], level)
        cnt = r[:count]
        if count[code].nil?
          count[code] = cnt
        elsif
          count[code] += cnt
        end
      end
    end

    addresses = Address.where(code: count.keys)

    counts_by_address_code = []
    count.each do |code, value|
      address = addresses.select{|a| a.code == code}.first
      counts_by_address_code << {
        address: address,
        count: value
      }
    end
    counts_by_address_code
  end
end
