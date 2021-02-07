class RailwayStation < ApplicationRecord
  include Swagger::StationSchema

  def location
    {
      lat: latitude,
      lng: longitude
    }
  end
end
