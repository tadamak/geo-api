class V1::Railways::StationsController < ApplicationController
  include Swagger::RailwaysApi

  before_action :validate_page_params, only: [:index]
  before_action :validate_distance_params, only: [:index]
  before_action :validate_embed_params, only: [:index, :show]
  before_action :validate_index_params, only: [:index]
  before_action :validate_show_params, only: [:show]
  before_action :get_stations, only: [:index]

  def index
    response.headers['X-Total-Count'] = @total
    render json: @stations
  end

  def show
    embed = params[:embed]&.split(',') || []
    @station.is_embed_address = true if embed.include?('address')
    render json: @station
  end

  private

  def validate_embed_params
    embed = params[:embed]&.split(',') || []
    enable_keys = ['address']
    embed.each do |e|
      return render_400(ErrorCode::INVALID_PARAM, 'embed の指定が誤っています。') unless enable_keys.include?(e)
    end
  end

  def validate_index_params
    enable_sort_keys = ['code', 'name', 'address_code']
    enable_sort_keys << 'distance' if params[:location].present?
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
    # 検索条件
    name = params[:name]
    address_code = params[:address_code]
    location = get_location
    radius = get_radius
    distance = "St_distance_sphere(ST_GeomFromText('POINT(#{location[:lng]} #{location[:lat]})', 4326), ST_GeomFromText(CONCAT('POINT(', longitude, ' ', latitude, ')'), 4326))" if location.present?
    sort = get_sort || [code: :asc]
    limit = get_limit
    offset = get_offset
    embed = params[:embed]&.split(',') || []

    # 検索条件設定
    stations = RailwayStation
    stations = stations.where('name LIKE ?', "%#{name}%") if name.present?
    stations = stations.where('address_code LIKE ?', "#{address_code}%") if address_code.present?
    stations = stations.where("#{distance} <= #{radius}") if location.present?

    # 合計件数取得
    @total = stations.count

    # 取得範囲設定
    stations = stations.select("*, #{distance} as distance") if location.present?
    stations = stations.order(sort).offset(offset).limit(limit)

    # 追加情報
    stations = stations.includes(:address) if embed.include?('address')
    stations.each do |s|
      s.is_embed_address = true if embed.include?('address')
    end
    @stations =stations
  end
end
