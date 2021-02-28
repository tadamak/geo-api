class RailwayStation < ApplicationRecord
  include Swagger::StationSchema

  belongs_to :address, class_name: 'Address', primary_key: 'code', foreign_key: 'address_code'

  def location
    {
      lat: latitude,
      lng: longitude
    }
  end
end
