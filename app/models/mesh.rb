class Mesh < ApplicationRecord
  include Swagger::MeshSchema

  # 地域メッシュ階層
  LEVEL = {
    THIRD:  3,
    FOURTH: 4,
    FIFTH:  5
  }

  def self.geojson(codes)
    results = self.select('code, ST_AsGeoJSON(polygon) as geojson').where(code: codes)
    features = []
    results.each do |result|
      geojson = result.attributes['geojson']
      features << {
        type: 'Feature',
        properties: {
          code: result.code
        },
        geometry: JSON.parse(geojson)
      }
    end
    return {
      type: 'FeatureCollection',
      features: features
    }
  end
end
