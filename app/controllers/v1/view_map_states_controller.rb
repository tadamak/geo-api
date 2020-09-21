class V1::ViewMapStatesController < ApplicationController
  before_action :validate_create_params, only: [:create]
  before_action :validate_show_params, only: [:show]

  def create
    @view_map_state = ViewMapState.new(view_map_state_params)
    @view_map_state.code = @view_map_state.generate_code
    @view_map_state.save!
    render json: @view_map_state
  end
  
  def show
    render json: @view_map_state
  end

  private

  def view_map_state_params
    params.require(:view_map_state).permit(:title, :zoom, :latitude, :longitude, :analysis_type, :analysis_level, locations: [:lat, :lng])
  end

  def validate_create_params
    p = view_map_state_params
    if p[:title].blank? || p[:zoom].blank? || p[:latitude].blank? || p[:longitude].blank? || p[:analysis_type].blank? || p[:locations].blank?
      return render_400(ErrorCode::REQUIRED_PARAM, 'パラメータが不足しています。')
    end
  end

  def validate_show_params
    code = params[:code]
    @view_map_state = ViewMapState.find_by(code: code)
    if @view_map_state.nil?
      return render_400(ErrorCode::REQUIRED_PARAM, '存在しない code を指定しています。')
    end
  end
end
