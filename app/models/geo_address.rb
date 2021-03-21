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
    each_slice_num = 100
    slice_locations = all_locations.each_slice(each_slice_num).to_a
    results = Parallel.map(slice_locations) do |locations|
      sql = ''
      locations.each do |l|
        sql += "UNION ALL\n" unless sql.empty?
        # NOTE: 都道府県のST_Containsが遅いため、最も下のレベル4(字・丁目)で解析をする
        sql += "SELECT address_code FROM geo_addresses WHERE (ST_Contains(polygon, ST_GEOMFROMTEXT('POINT(#{l[:lng]} #{l[:lat]})', 4326))) AND level = #{Address::LEVEL[:CHOME]}\n"
      end
      self.find_by_sql("SELECT t.address_code FROM (#{sql}) as t").pluck(:address_code)
    end

    address_codes = results.flatten
    # 重複する住所コードでまとめて件数を取得する {address_code => count}
    countResults = address_codes.group_by(&:itself).map{ |key, value| [key, value.count] }.to_h

    count = {}
    countResults.each do |key, value|
      code = Address.code_by_level(key, level)
      if count[code].nil?
        count[code] = value
      elsif
        count[code] += value
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
