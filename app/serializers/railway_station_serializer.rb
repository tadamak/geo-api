class RailwayStationSerializer < ActiveModel::Serializer
  attributes :code, :name, :address_code, :address_name, :location
  attribute :distance, if: :has_distance?

  def has_distance?
    object.has_attribute?(:distance)
  end

  def distance
    object.distance.to_i
  end
end
