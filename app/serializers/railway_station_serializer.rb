class RailwayStationSerializer < ActiveModel::Serializer
  attributes :code, :name, :address_code, :address_name, :location, :distance

  def distance
    if object.has_attribute?(:distance)
      return object.distance.to_i
    end
    return nil
  end
end
