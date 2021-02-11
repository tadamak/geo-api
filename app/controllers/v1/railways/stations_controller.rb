class V1::Railways::StationsController < ApplicationController
  include Swagger::RailwaysApi

  before_action :validate_page_params, only: [:index]
  before_action :validate_index_params, only: [:index]
  before_action :validate_show_params, only: [:show]

  def index
    stations = get_stations
    total = stations.count
    stations = stations.offset(@offset).limit(@limit)
    response.headers['X-Total-Count'] = total

    render json: stations
  end

  def show
    render json: @station
  end

  private

  def validate_index_params
    enable_sort_keys = ['address_code', 'name', 'code']
    sort = params[:sort]
    if sort.present? && !is_enable_sort_key?(enable_sort_keys)
      return render_400(ErrorCode::INVALID_PARAM, 'sort の指定が誤っています。')
    end
  end

  def validate_show_params
    code = params[:code]
    @station = RailwayStation.find_by(code: code)
    if @station.nil?
      return render_400(ErrorCode::INVALID_PARAM, '存在しない code を指定しています。')
    end
  end

  def get_stations
    name = params[:name]
    address_code = params[:address_code]
    sort = get_sort || [address_code: :asc]

    stations = RailwayStation
    stations = stations.where("MATCH (name) AGAINST ('+#{name}' IN BOOLEAN MODE)") if name.present?
    stations = stations.where('address_code LIKE ?', "#{address_code}%") if address_code.present?
    stations = stations.order(sort)
    return stations
  end
end
