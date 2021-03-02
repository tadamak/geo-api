class SchoolDistrictSerializer < ActiveModel::Serializer
  attributes :code, :school_type, :school_name, :school_address, :location, :year
  attribute :distance, if: :has_distance?
  belongs_to :address, class_name: 'Address', primary_key: :code, foreign_key: :address_code, if: :include_address?
  belongs_to :school, class_name: 'School', primary_key: :code, foreign_key: :school_code, if: :include_school?

  def include_address?
    object.is_embed_address
  end

  def include_school?
    object.is_embed_school
  end

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
