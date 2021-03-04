class RailwayLine < ApplicationRecord
  include Swagger::LineSchema

  def location
    {
      lat: latitude,
      lng: longitude
    }
  end
end
