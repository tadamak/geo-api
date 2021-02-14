class AddressSerializer < ActiveModel::Serializer
  attributes :code, :name, :level, :location, :area, :details, :distance

  def distance
    if object.has_attribute?(:distance)
      return object.distance.to_i
    end
    return nil
  end
end
