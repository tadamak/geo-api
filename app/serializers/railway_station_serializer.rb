class RailwayStationSerializer < ActiveModel::Serializer
  attributes :code, :name, :location
  attribute :distance, if: :has_distance?
  belongs_to :address, class_name: 'Address', primary_key: :code, foreign_key: :address_code, if: :include_address?

  def include_address?
    object.is_embed_address
  end

  def has_distance?
    object.has_attribute?(:distance)
  end

  def distance
    object.distance.to_i
  end
end
