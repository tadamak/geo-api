class ViewMapStateSerializer < ActiveModel::Serializer
  attributes :id, :code, :title, :description, :zoom, :location, :analysis_type, :analysis_level, :map_theme, :polygon_color, :count_range_from, :count_range_to, :locations, :created_at, :updated_at

  def analysis_type
    object.analysis_type_before_type_cast
  end

  def map_theme
    object.map_theme_before_type_cast
  end
end
