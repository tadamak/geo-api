class Mesh < ApplicationRecord
  include Swagger::MeshSchema

  # 地域メッシュ階層
  LEVEL = {
    FIRST:  1,
    SECOND: 2,
    THIRD:  3,
    FOURTH: 4,
    FIFTH:  5
  }

  # 地域メッシュコード桁数
  CODE_DIGIT = {
    FIRST:  4,
    SECOND: 6,
    THIRD:  8,
    FOURTH: 9,
    FIFTH:  10
  }

  def details
    details = []
    level.times do |i|
      l = i + 1
      details << {
        code: code_by_level(l),
        level: l
      }
    end
    details
  end

  # 複数メッシュを1つのGeoJSONに変換する (Mesh:GeoJSON = N:1)
  def self.geojson(codes)
    results = self.select('code, ST_AsGeoJSON(polygon) as geojson').where(code: codes)
    features = []
    results.each do |result|
      features << {
        type: 'Feature',
        properties: {
          code: result.code
        },
        geometry: JSON.parse(result.attributes['geojson'])
      }
    end
    return {
      type: 'FeatureCollection',
      features: features
    }
  end

  # メッシュ単位にGeoJSONを生成する (Mesh:GeoJSON = 1:1)
  def self.geojsons(codes)
    results = self.select('code, ST_AsGeoJSON(polygon) as geojson').where(code: codes)
    geojsons = []
    results.each do |result|
      geojsons << {
        type: 'FeatureCollection',
        features: [
          {
            type: 'Feature',
            properties: {
              code: result.code
            },
            geometry: JSON.parse(result.attributes['geojson'])
          }
        ]
      }
    end
    return geojsons
  end

  def self.counts_by_code(locations, level)
    sql = ''
    locations.each do |l|
      lat = l.split(',')[0]
      lng = l.split(',')[1]
      sql += "UNION ALL\n" unless sql.empty?
      sql += "SELECT code FROM meshes WHERE (ST_Contains(polygon, ST_GEOMFROMTEXT('POINT(#{lng} #{lat})', 4326))) AND level = #{level}\n"
    end

    meshCounts = self.find_by_sql("
      SELECT t.code, count(*) as count
      FROM (#{sql}) as t
      GROUP BY t.code;")

    meshes = Mesh.where(code: meshCounts.pluck(:code))

    counts_by_code = []
    meshCounts.each do |meshCount|
      mesh = meshes.select{|m| m.code == meshCount.code}.first
      counts_by_code << {
        mesh: mesh,
        count: meshCount.attributes['count']
      }
    end
    counts_by_code
  end

  private

  def code_by_level(level)
    case level
    when LEVEL[:FIRST] then
      c = code[0, CODE_DIGIT[:FIRST]]
    when LEVEL[:SECOND] then
      c = code[0, CODE_DIGIT[:SECOND]]
    when LEVEL[:THIRD] then
      c = code[0, CODE_DIGIT[:THIRD]]
    when LEVEL[:FOURTH] then
      c = code[0, CODE_DIGIT[:FOURTH]]
    when LEVEL[:FIFTH] then
      c = code[0, CODE_DIGIT[:FIFTH]]
    end
    c
  end
end
