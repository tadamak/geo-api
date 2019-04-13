class Address < ApplicationRecord
  attr_accessor :lat, :lng

  default_scope { select('*, X(coordinate) as lng, Y(coordinate) as lat') }

  def lat
    self.attributes['lat']
  end

  def lng
    self.attributes['lng']
  end
end
