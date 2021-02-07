class RailwayStation < ApplicationRecord
  include Swagger::StationSchema

  def location
    return nil if latitude.nil? || longitude.nil?
    {
      lat: latitude,
      lng: longitude
    }
  end
end
