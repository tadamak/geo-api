class Address < ApplicationRecord
  attr_accessor :lat, :lng

  LEVEL = {
    PREF:  1,
    CITY:  2,
    TOWN:  3,
    BLOCK: 4
  }

  default_scope { select('*, X(coordinate) as lng, Y(coordinate) as lat') }

  def lat
    self.attributes['lat']
  end

  def lng
    self.attributes['lng']
  end
end
