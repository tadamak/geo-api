class SchoolDistrictSerializer < ActiveModel::Serializer
  attributes :code, :address_code, :school_code, :school_type, :school_name, :school_address, :location, :year, :distance

  def school_type
    object.school_type_before_type_cast
  end

  def distance
    if object.has_attribute?(:distance)
      return object.distance.to_i
    end
    return nil
  end
end
