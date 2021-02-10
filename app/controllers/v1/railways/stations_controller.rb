class V1::Railways::StationsController < ApplicationController
  include Swagger::RailwaysApi

  before_action :validate_page_params, only: [:index]
  before_action :validate_show_params, only: [:show]

  def index
    address_code = params[:address_code]
    stations = RailwayStation
    stations = stations.where('address_code LIKE ?', "#{address_code}%") if address_code.present?

    total = stations.count
    stations = stations.offset(@offset).limit(@limit).order(address_code: :asc)
    response.headers['X-Total-Count'] = total
    render json: stations
  end

  def show
    render json: @station
  end

  private

  def validate_show_params
    code = params[:code]
    @station = RailwayStation.find_by(code: code)
    if @station.nil?
      return render_400(ErrorCode::INVALID_PARAM, '存在しない code を指定しています。')
    end
  end
end
