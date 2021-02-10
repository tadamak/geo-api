class V1::AddressesController < ApplicationController
  include Swagger::AddressesApi

  before_action :validate_page_params, only: [:index, :index_shape]
  before_action :validate_index_params, only: [:index, :index_shape]
  before_action :validate_show_params, only: [:show, :show_shape]
  before_action :validate_geocoding_params, only: [:geocoding]

  def index
    addresses = get_addresses
    total = addresses.count
    addresses = addresses.offset(get_offset).limit(get_limit).order(code: :asc)
    response.headers['X-Total-Count'] = total
    render json: addresses
  end

  def index_shape
    addresses = get_addresses
    total = addresses.count
    addresses = addresses.offset(get_offset).limit(get_limit).order(code: :asc)

    response.headers['X-Total-Count'] = total

    if params[:merged] == 'false'
      geojson = GeoAddress.geojsons(addresses.pluck(:code))
    else
      geojson = GeoAddress.geojson(addresses.pluck(:code))
    end
    render json: geojson
  end

  def show
    render json: @address
  end

  def show_shape
    render json: GeoAddress.geojsons(@address.code).first
  end

  def geocoding
    location = params[:location]
    lat = location.split(',')[0]
    lng = location.split(',')[1]
    geo_address = GeoAddress.reverse_geocoding(lat, lng)
    address = Address.find_by(code: geo_address.address_code)
    render json: address
  end

  private

  def validate_index_params
    level = params[:level]
    if level.present? && !Address::LEVEL.values.include?(level.to_i)
      return render_400(ErrorCode::INVALID_PARAM, 'level の指定が誤っています。')
    end
  end

  def validate_show_params
    code = params[:code]
    @address = Address.find_by(code: code)
    if @address.nil?
      return render_400(ErrorCode::INVALID_PARAM, '存在しない code を指定しています。')
    end
  end

  def validate_geocoding_params
    location = params[:location]
    if location.blank?
      return render_400(ErrorCode::REQUIRED_PARAM, 'location の指定が必要です。')
    end
  end

  def get_addresses
    name = params[:name]
    level = params[:level]
    codes = params[:codes]
    parent_code = params[:parent_code]

    addresses = Address
    addresses = addresses.where("MATCH (pref_name,city_name,town_name) AGAINST ('+#{name}' IN BOOLEAN MODE)") if name.present?
    addresses = addresses.where(level: level) if level.present?
    addresses = addresses.where(code: codes.split(',')) if codes.present?
    addresses = addresses.where('code LIKE ?', "#{parent_code}%") if parent_code.present?
    return addresses
  end
end
