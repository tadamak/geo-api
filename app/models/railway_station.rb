class RailwayStation < ApplicationRecord
  include Swagger::StationSchema

  attr_accessor :is_embed_address

  belongs_to :address, class_name: 'Address', primary_key: :code, foreign_key: :address_code

  def location
    {
      lat: latitude,
      lng: longitude
    }
  end
end
