class SchoolSerializer < ActiveModel::Serializer
  attributes :id, :name, :school_type, :school_admin, :address_code, :address_name, :location

  def school_type
    object.school_type_before_type_cast
  end

  def school_admin
    object.school_admin_before_type_cast
  end
end
