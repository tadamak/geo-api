class V1::Railways::StationsController < ApplicationController
  include Swagger::RailwaysApi

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
    limit = params[:limit].to_i
    offset = params[:offset].to_i
    address_code = params[:address_code]

    if limit < 0
      return render_400(ErrorCode::INVALID_PARAM, "limit には正の整数を指定してください。")
    end
    if limit > Constants::MAX_LIMIT
      return render_400(ErrorCode::INVALID_PARAM, "limit の指定数が最大値(#{Constants::MAX_LIMIT}件)を超えています。")
    end
    if offset < 0
      return render_400(ErrorCode::INVALID_PARAM, "offset には正の整数を指定してください。")
    end
    if address_code.blank?
      return render_400(ErrorCode::REQUIRED_PARAM, 'address_code の指定が必要です。')
    end
  end

  def validate_show_params
    code = params[:code]
    @station = RailwayStation.find_by(code: code)
    if @station.nil?
      return render_400(ErrorCode::REQUIRED_PARAM, '存在しない code を指定しています。')
    end
  end
end
