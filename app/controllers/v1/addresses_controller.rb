class V1::AddressesController < ApplicationController
  include Swagger::AddressesApi

  before_action :validate_index_params, only: [:index]
  before_action :validate_search_params, only: [:search]
  before_action :validate_geocoding_params, only: [:geocoding]
  before_action :validate_shapes_params, only: [:shapes]

  def index
    @addresses = Address.where(code: params[:codes].split(','))
  end

  def search
    if params[:word].present?
      @addresses = Address.where('name LIKE ?', "%#{params[:word]}%")
    else
      search_level = get_search_level # 一階層下の住所レベルを取得
      @addresses = Address.where(level: search_level)
      @addresses = @addresses.where('code LIKE ?', "#{@address.code}%") if @address.present?
    end

    offset = get_offset
    limit = get_limit
    total = @addresses.unscope(:select).count
    @addresses = @addresses.offset(offset).limit(limit)

    response.headers['X-Total-Count'] = total
  end

  def geocoding
    locations = params[:locations].split(':')
    codes = []
    locations.each do |location|
      lat = location.split(',')[0]
      lng = location.split(',')[1]
      geo_address = GeoAddress.reverse_geocoding(lat, lng)
      codes << geo_address.address_code if geo_address.present?
    end
    @addresses = Address.where(code: codes)
  end

  def shapes
    @geojsons = []
    codes = params[:codes].split(',')
    codes.each do |code|
      @geojsons << GeoAddress.geojson(code)
    end
  end

  private

  def validate_index_params
    codes = params[:codes]
    render status: :bad_request, json: { status: 400, message: 'Parameter(codes) is required.' } if codes.blank?
  end

  def validate_search_params
    code = params[:code]
    if code.present?
      @address = Address.find_by(code: code)
      render status: :bad_request, json: { status: 400, message: 'Invalid address code.' } if @address.nil?
    end
  end

  def validate_geocoding_params
    locations = params[:locations]
    render status: :bad_request, json: { status: 400, message: 'Parameter(locations) is required.' } if locations.blank?
  end

  def validate_shapes_params
    codes = params[:codes]
    render status: :bad_request, json: { status: 400, message: 'Parameter(codes) is required.' } if codes.blank?
  end

  def get_search_level
    if @address.nil?
      Address::LEVEL[:PREF]
    else
      @address.level + 1
    end
  end

  def get_limit
    limit = params[:limit].blank? ? Constants::DEFAULT_LIMIT : params[:limit].to_i
    limit = Constants::MAX_LIMIT if limit > Constants::MAX_LIMIT
    limit
  end

  def get_offset
    params[:offset].blank? ? Constants::DEFAULT_OFFSET : params[:offset].to_i
  end
end
