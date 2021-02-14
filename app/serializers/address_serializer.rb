class AddressSerializer < ActiveModel::Serializer
  attributes :code, :name, :level, :location, :area, :details
  attribute :distance, if: :has_distance?

  def has_distance?
    object.has_attribute?(:distance)
  end

  def distance
    object.distance.to_i
  end
end
