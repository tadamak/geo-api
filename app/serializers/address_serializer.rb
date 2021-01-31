class AddressSerializer < ActiveModel::Serializer
  attributes :code, :name, :level, :location, :area, :details
end
