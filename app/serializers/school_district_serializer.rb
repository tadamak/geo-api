class SchoolDistrictSerializer < ActiveModel::Serializer
  attributes :address_code, :school_type, :school_name, :school_address, :location

  def school_type
    object.school_type_before_type_cast
  end
end
