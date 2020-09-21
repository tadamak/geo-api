class ViewMapStateSerializer < ActiveModel::Serializer
  attributes :id, :code, :title, :zoom, :location, :analysis_type, :analysis_level, :locations, :created_at, :updated_at

  def analysis_type
    object.analysis_type_before_type_cast
  end
end
