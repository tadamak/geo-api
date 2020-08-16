class TopoAddress < ApplicationRecord

  FORMAT = 'topojson'

  # 住所単位にTopoJSONを生成する
  def self.topojsons(address_codes)
    results = self.select(:polygon).where(address_code: address_codes)
    results.map do |result|
      result.polygon
    end
  end
end
