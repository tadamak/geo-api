class SchoolSerializer < ActiveModel::Serializer
  attributes :code, :name, :school_type, :school_admin, :school_address, :location
  attribute :distance, if: :has_distance?
  belongs_to :address, class_name: 'Address', primary_key: :code, foreign_key: :address_code, if: :include_address?
  has_one :school_district, class_name: 'SchoolDistrict', primary_key: :code, foreign_key: :school_code, if: :include_school_district?

  def include_address?
    object.is_embed_address
  end

  def include_school_district?
    object.is_embed_school_district
  end

  def school_type
    object.school_type_before_type_cast
  end

  def school_admin
    object.school_admin_before_type_cast
  end

  def school_district_code
    object.school_district&.code
  end

  def has_distance?
    object.has_attribute?(:distance)
  end

  def distance
    object.distance.to_i
  end
end