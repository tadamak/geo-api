class SchoolDistrictSerializer < ActiveModel::Serializer
  attributes :code, :address_code, :school_code, :school_type, :school_name, :school_address, :location, :year
  attribute :distance, if: :has_distance?

  def school_type
    object.school_type_before_type_cast
  end

  def has_distance?
    object.has_attribute?(:distance)
  end

  def distance
    object.distance.to_i
  end
end
