class V1::SchoolDistrictsController < ApplicationController
  include Swagger::SchoolDistrictsApi

  before_action :validate_index_params, only: [:index, :index_shape]
  before_action :validate_show_params, only: [:show, :show_shape, :show_address, :show_school_district]
  before_action :validate_search_params, only: [:search]

  def index
    address_code = params[:address_code]
    school_type = params[:school_type]
    school_districts = SchoolDistrict.select(:code, :address_code, :school_code, :school_name, :school_type, :school_address, :latitude, :longitude).where('address_code LIKE ?', "#{address_code}%")
    if school_type.present?
      school_districts = school_districts.where(school_type: school_type)
    end
    render json: school_districts
  end
  
  def show
    code = params[:code]
    school_district = SchoolDistrict.select(:code, :address_code, :school_code, :school_name, :school_type, :school_address, :latitude, :longitude).find_by(code: code)
    render json: school_district
  end

  def search
    q = params[:word]
    # 全文検索 (完全一致)
    school_districts = SchoolDistrict.select("code, address_code, school_code, school_name, school_type, school_address, latitude, longitude")
                                     .where("MATCH (school_name) AGAINST ('+#{q}' IN BOOLEAN MODE)")
    # 全文検索 (揺らぎ考慮)
    # school_districts = SchoolDistrict.select("code, address_code, school_code, school_name, school_type, school_address, latitude, longitude, MATCH (school_name) AGAINST ('#{q}') AS score")
    #                                  .where("MATCH (school_name) AGAINST ('#{q}')")
    #                                  .having('score > ?', 1)
    #                                  .order(score: :desc)
    offset = get_offset
    limit = get_limit
    total = school_districts.length
    school_districts = school_districts.offset(offset).limit(limit)

    response.headers['X-Total-Count'] = total
    render json: school_districts
  end

  def index_shape
    address_code = params[:address_code]
    school_type = params[:school_type]
    school_districts = SchoolDistrict.where('address_code LIKE ?', "#{address_code}%")
    school_districts = school_districts.where(school_type: school_type) unless school_type.nil?
    render json: school_districts.geojsons
  end

  def show_shape
    code = params[:code]
    school_district = SchoolDistrict.where(code: code)
    render json: school_district.geojsons.first
  end

  def show_address
    code = params[:code]
    filter = params[:filter]
    address_code = @school_district.address_code.slice(0, Address::CODE_DIGIT[:CITY])
    subquery = "SELECT polygon FROM school_districts WHERE code = '#{code}'"
    geo_addresses = GeoAddress.where(level: Address::LEVEL[:TOWN])
                              .where('address_code LIKE ?', "#{address_code}%")
                              .where("ST_Intersects((#{subquery}), polygon)")
                              .where.not("ST_Touches((#{subquery}), polygon)")

    # 住所と学区のポリゴンデータは作成元が異なるため、僅かな重なりが発生してしまう。
    # そのため、住所の面積と、学区と住所の重なった面積(積集合)の割合を求め、重なり割合が 3% 未満のものは誤差として除外する。
    # さらに、重なり割合が 97% 以上の場合は完全に含んでいると判断する。
    address_codes = geo_addresses.pluck(:address_code)
    results = GeoAddress.select("address_code, ST_Area(polygon) AS area1, ST_Area(ST_Intersection(polygon, (#{subquery}))) AS area2").where(address_code: address_codes)
    filtered_results = []
    results.each do |r|
      overlap_ratio = r.area2 / r.area1 * 100 # 住所と学区の重なり割合
      next if overlap_ratio < 3.0
      if filter == SchoolDistrict::FILTER[:CONTAIN]
        next if overlap_ratio < 97.0
      elsif filter == SchoolDistrict::FILTER[:PARTIAL]
        next if overlap_ratio >= 97.0
      end
      filtered_results << r
    end
    address_codes = filtered_results.map { |r| r.address_code }

    addresses = Address.where(code: address_codes)
    render json: addresses
  end

  def show_school_district
    code = params[:code]
    filter = params[:filter]
    school_type = params[:school_type]
    address_code = @school_district.address_code.slice(0, Address::CODE_DIGIT[:CITY])
    subquery = "SELECT polygon FROM school_districts WHERE code = '#{code}'"
    school_districts = SchoolDistrict.select(:code, :address_code, :school_code, :school_name, :school_type, :school_address, :latitude, :longitude)
                                     .where.not(code: code)
    if filter == SchoolDistrict::FILTER[:CONTAIN]
      school_districts = school_districts.where("ST_Contains((#{subquery}), polygon)")
    elsif filter == SchoolDistrict::FILTER[:PARTIAL]
      school_districts = school_districts.where("ST_Intersects((#{subquery}), polygon)")
                                         .where.not("ST_Touches((#{subquery}), polygon)")
                                         .where.not("ST_Contains((#{subquery}), polygon)")
    elsif filter == SchoolDistrict::FILTER[:TOUCH]
      school_districts = school_districts.where("ST_Touches((#{subquery}), polygon)")
    else
      school_districts = school_districts.where("ST_Intersects((#{subquery}), polygon)")
                                         .where.not("ST_Touches((#{subquery}), polygon)")
    end
    school_districts = school_districts.where(school_type: school_type) unless school_type.nil?
    render json: school_districts
  end

  private

  def validate_index_params
    address_code = params[:address_code]
    school_type = params[:school_type]
    if address_code.blank?
      return render_400(ErrorCode::REQUIRED_PARAM, 'address_code の指定が必要です。')
    elsif address_code.length != Address::CODE_DIGIT[:CITY]
      return render_400(ErrorCode::INVALID_PARAM, "address_code はレベル2(市区町村)を指定してください。")
    end
    if school_type.present? && !SchoolDistrict.school_types.values.include?(school_type.to_i)
      return render_400(ErrorCode::INVALID_PARAM, "誤った school_type を指定しています。")
    end
  end

  def validate_show_params
    code = params[:code]
    @school_district = SchoolDistrict.find_by(code: code)
    if @school_district.nil?
      return render_400(ErrorCode::REQUIRED_PARAM, '存在しない code を指定しています。')
    end
  end

  def validate_search_params
    word = params[:word]
    if word.blank?
      return render_400(ErrorCode::REQUIRED_PARAM, 'word の指定が必要です。')
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
