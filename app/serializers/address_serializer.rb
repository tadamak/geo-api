class AddressSerializer < ActiveModel::Serializer
  attributes :code, :name, :level, :location, :details

  def location
    { lat: object[:lat], lng: object[:lng] }
  end
end
