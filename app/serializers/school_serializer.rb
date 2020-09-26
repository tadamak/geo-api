class SchoolSerializer < ActiveModel::Serializer
  attributes :code, :name, :school_type, :school_admin, :school_address, :address_code, :location

  def school_type
    object.school_type_before_type_cast
  end

  def school_admin
    object.school_admin_before_type_cast
  end
end
