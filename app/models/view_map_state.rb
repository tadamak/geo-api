class ViewMapState < ApplicationRecord

  enum analysis_type: { address: 1, mesh: 2, heatmap: 3, cluster: 4 }

  def location
    return nil if latitude.nil? || longitude.nil?
    {
      lat: latitude,
      lng: longitude
    }
  end

  def generate_code
    key = "#{title}#{locations}#{Time.now}"
    Digest::MD5.hexdigest(key)
  end
end
