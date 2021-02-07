class V1::AddressesController < ApplicationController
  include Swagger::AddressesApi

  before_action :validate_index_params, only: [:index]
  before_action :validate_search_params, only: [:search]
  before_action :validate_geocoding_params, only: [:geocoding]
  before_action :validate_shape_params, only: [:shape]

  def index
    addresses = Address.where(code: params[:codes].split(','))
    render json: addresses
  end

  def search
    if params[:word].present?
      q = params[:word]
      # 全文検索 (完全一致)
      addresses = Address.where("MATCH (pref_name,city_name,town_name) AGAINST ('+#{q}' IN BOOLEAN MODE)")
      # 全文検索 (揺らぎ考慮)
      # addresses = Address.select("*, MATCH (pref_name,city_name,town_name) AGAINST ('#{q}') AS score")
      #                    .where("MATCH (pref_name,city_name,town_name) AGAINST ('#{q}')")
      #                    .having('score > ?', 1)
      #                    .order(score: :desc)
      addresses = addresses.where(level: params[:level]) if params[:level].present?
      total = addresses.length
    else
      search_level = get_search_level # 一階層下の住所レベルを取得
      addresses = Address.where(level: search_level)
      addresses = addresses.where('code LIKE ?', "#{@address.code}%") if @address.present?
      total = addresses.unscope(:select).count
    end

    offset = get_offset
    limit = get_limit
    addresses = addresses.offset(offset).limit(limit).order(code: :asc)

    response.headers['X-Total-Count'] = total
    render json: addresses
  end

  def geocoding
    location = params[:location]
    lat = location.split(',')[0]
    lng = location.split(',')[1]
    geo_address = GeoAddress.reverse_geocoding(lat, lng)
    address = Address.find_by(code: geo_address.address_code)
    render json: address
  end

  def shapes
    codes = params[:codes].split(',')
    if params[:type] == TopoAddress::FORMAT
      render json: TopoAddress.topojsons(codes)
    else
      render json: GeoAddress.geojsons(codes)
    end
  end

  private

  def validate_index_params
    codes = params[:codes]&.split(',')
    if codes.blank?
      return render_400(ErrorCode::REQUIRED_PARAM, 'codes の指定が必要です。')
    elsif codes.length > Constants::MAX_LIMIT
      return render_400(ErrorCode::INVALID_PARAM, "codes の指定数が最大値(#{Constants::MAX_LIMIT}件)を超えています。")
    end
  end

  def validate_search_params
    limit = params[:limit].to_i
    offset = params[:offset].to_i
    code = params[:code]
    if limit < 0
      return render_400(ErrorCode::INVALID_PARAM, "limit には正の整数を指定してください。")
    end
    if limit > Constants::MAX_LIMIT
      return render_400(ErrorCode::INVALID_PARAM, "limit の指定数が最大値(#{Constants::MAX_LIMIT}件)を超えています。")
    end
    if offset < 0
      return render_400(ErrorCode::INVALID_PARAM, "offset には正の整数を指定してください。")
    end
    if code.present?
      @address = Address.find_by(code: code)
      if @address.nil?
        return render_400(ErrorCode::INVALID_PARAM, "存在しない住所コードを指定しています。")
      end
    end
  end

  def validate_geocoding_params
    location = params[:location]
    if location.blank?
      return render_400(ErrorCode::REQUIRED_PARAM, 'location の指定が必要です。')
    end
  end

  def validate_shape_params
    codes = params[:codes]&.split(',')
    type = params[:type]
    if codes.blank?
      return render_400(ErrorCode::REQUIRED_PARAM, 'codes の指定が必要です。')
    elsif codes.length > Constants::MAX_LIMIT
      return render_400(ErrorCode::INVALID_PARAM, "codes の指定数が最大値(#{Constants::MAX_LIMIT}件)を超えています。")
    end
    if type.present? && ![GeoAddress::FORMAT, TopoAddress::FORMAT].include?(type)
      return render_400(ErrorCode::INVALID_PARAM, "誤った type を指定しています。")
    end
  end

  def get_search_level
    if @address.nil?
      Address::LEVEL[:PREF]
    else
      @address.level + 1
    end
  end
end
