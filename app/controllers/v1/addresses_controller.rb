class V1::AddressesController < ApplicationController
  include Swagger::AddressesApi

  before_action :validate_page_params, only: [:index, :index_shape]
  before_action :validate_distance_params, only: [:index, :index_shape]
  before_action :validate_index_params, only: [:index, :index_shape]
  before_action :validate_show_params, only: [:show, :show_shape]
  before_action :validate_geocoding_params, only: [:geocoding]
  before_action :get_addresses, only: [:index, :index_shape]

  def index
    response.headers['X-Total-Count'] = @total
    render json: @addresses
  end

  def index_shape
    response.headers['X-Total-Count'] = @total
    if params[:merged] == 'false'
      geojson = GeoAddress.geojsons(@addresses.pluck(:code))
    else
      geojson = GeoAddress.geojson(@addresses.pluck(:code))
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
    enable_sort_keys = ['code', 'kana', 'level', 'area']
    enable_sort_keys << 'distance' if params[:location].present?
    sort = params[:sort]
    level = params[:level]
    if sort.present? && !is_enable_sort_key?(enable_sort_keys)
      return render_400(ErrorCode::INVALID_PARAM, 'sort の指定が誤っています。')
    end
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
    # 検索条件
    name = params[:name]
    level = params[:level]
    codes = params[:code]
    parent_code = params[:parent_code]
    location = get_location
    radius = get_radius
    distance = "St_distance_sphere(ST_GeomFromText('POINT(#{location[:lng]} #{location[:lat]})', 4326), ST_GeomFromText(CONCAT('POINT(', longitude, ' ', latitude, ')'), 4326))" if location.present?
    sort = get_sort || [code: :asc]
    limit = get_limit
    offset = get_offset

    # 検索条件設定
    addresses = Address
    addresses = addresses.where("MATCH (name, kana) AGAINST ('+#{name}' IN BOOLEAN MODE)") if name.present?
    addresses = addresses.where(level: level) if level.present?
    addresses = addresses.where(code: codes.split(',')) if codes.present?
    addresses = addresses.where('code LIKE ?', "#{parent_code}%") if parent_code.present?
    addresses = addresses.where("#{distance} <= #{radius}") if location.present?

    # 合計件数取得
    @total = addresses.count

    # 取得範囲設定
    addresses = addresses.select("*, #{distance} as distance") if location.present?
    addresses = addresses.order(sort).offset(offset).limit(limit)

    @addresses =addresses
  end
end
