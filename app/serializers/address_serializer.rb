class AddressSerializer < ActiveModel::Serializer
  attributes :code, :name, :level, :location, :details
end
