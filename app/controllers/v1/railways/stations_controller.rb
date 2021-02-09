class V1::Railways::StationsController < ApplicationController
  include Swagger::RailwaysApi

  before_action :validate_page_params, only: [:index]
  before_action :validate_index_params, only: [:index]
  before_action :validate_show_params, only: [:show]

  def index
    address_code = params[:address_code]
    stations = RailwayStation.where('address_code LIKE ?', "#{address_code}%")

    total = stations.count
    offset = get_offset
    limit = get_limit
    stations = stations.offset(offset).limit(limit).order(address_code: :asc)

    response.headers['X-Total-Count'] = total
    render json: stations
  end

  def show
    render json: @station
  end

  private

  def validate_index_params
    address_code = params[:address_code]
    if address_code.blank?
      return render_400(ErrorCode::REQUIRED_PARAM, 'address_code の指定が必要です。')
    end
  end

  def validate_show_params
    code = params[:code]
    @station = RailwayStation.find_by(code: code)
    if @station.nil?
      return render_400(ErrorCode::INVALID_PARAM, '存在しない code を指定しています。')
    end
  end
end
