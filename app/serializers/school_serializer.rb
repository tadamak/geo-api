class SchoolSerializer < ActiveModel::Serializer
  attributes :code, :name, :school_type, :school_admin, :school_address, :address_code, :location, :school_district_code, :distance

  def school_type
    object.school_type_before_type_cast
  end

  def school_admin
    object.school_admin_before_type_cast
  end

  def school_district_code
    object.school_district&.code
  end

  def distance
    if object.has_attribute?(:distance)
      return object.distance.to_i
    end
    return nil
  end
end