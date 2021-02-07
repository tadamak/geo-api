class RailwayStationSerializer < ActiveModel::Serializer
  attributes :code, :name, :address_code, :address_name, :location
end
