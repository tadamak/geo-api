class V1::SchoolDistrictsController < ApplicationController
  include Swagger::SchoolDistrictsApi

  before_action :validate_page_params, only: [:index, :index_shape, :show_address, :show_school_district]
  before_action :validate_distance_params, only: [:index, :index_shape]
  before_action :validate_index_params, only: [:index, :index_shape]
  before_action :validate_show_params, only: [:show, :show_shape, :show_address, :show_school_district]
  before_action :validate_show_address_params, only: [:show_address]
  before_action :validate_show_school_district_params, only: [:show_school_district]
  before_action :get_school_districts, only: [:index, :index_shape]

  def index
    response.headers['X-Total-Count'] = @total
    render json: @school_districts
  end

  def index_shape
    response.headers['X-Total-Count'] = @total
    if params[:merged] == 'false'
      geojson = @school_districts.geojsons
    else
      geojson = @school_districts.geojson
    end
    render json: geojson
  end

  def show
    render json: @school_district
  end

  def show_shape
    render json: SchoolDistrict.where(code: params[:code]).geojsons.first
  end

  def show_address
    code = params[:code]
    filter = params[:filter]
    sort = get_sort || [code: :asc]
    limit = get_limit
    offset = get_offset

    address_code = @school_district.address_code.slice(0, Address::CODE_DIGIT[:CITY])
    subquery = "SELECT polygon FROM school_districts WHERE code = '#{code}'"
    geo_addresses = GeoAddress.where(level: Address::LEVEL[:CHOME])
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

    addresses = Address.where(code: address_codes).order(sort)
    total = addresses.count
    addresses = addresses.offset(offset).limit(limit)
    response.headers['X-Total-Count'] = total

    render json: addresses
  end

  def show_school_district
    code = params[:code]
    filter = params[:filter]
    school_type = params[:school_type]
    sort = get_sort || [code: :asc]
    limit = get_limit
    offset = get_offset

    address_code = @school_district.address_code.slice(0, Address::CODE_DIGIT[:CITY])
    subquery = "SELECT polygon FROM school_districts WHERE code = '#{code}'"
    school_districts = SchoolDistrict.where.not(code: code).order(sort)
    # MEMO: クエリの実行が極端に遅くなる学区があるため市区町村を指定している (ex. sd-1-xn77jtjku)
    school_districts = school_districts.where('address_code LIKE ?', "#{address_code}%")
    school_districts = school_districts.where(school_type: school_type) if school_type.present?
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

    total = school_districts.count
    school_districts = school_districts.select(:code, :address_code, :school_code, :school_name, :school_type, :school_address, :latitude, :longitude, :year).offset(offset).limit(limit)
    response.headers['X-Total-Count'] = total

    render json: school_districts
  end

  private

  def validate_index_params
    enable_sort_keys = ['code', 'school_name', 'address_code']
    enable_sort_keys << 'distance' if params[:location].present?
    sort = params[:sort]
    address_code = params[:address_code]
    school_type = params[:school_type]
    if sort.present? && !is_enable_sort_key?(enable_sort_keys)
      return render_400(ErrorCode::INVALID_PARAM, 'sort の指定が誤っています。')
    end
    if address_code.present? && address_code.length != Address::CODE_DIGIT[:CITY]
      return render_400(ErrorCode::INVALID_PARAM, "address_code はレベル2(市区町村)を指定してください。")
    end
    if school_type.present? && !SchoolDistrict.school_types.values.include?(school_type.to_i)
      return render_400(ErrorCode::INVALID_PARAM, "誤った school_type を指定しています。")
    end
  end

  def validate_show_params
    code = params[:code]
    @school_district = SchoolDistrict.select(:code, :address_code, :school_code, :school_name, :school_type, :school_address, :latitude, :longitude, :year).find_by(code: code)
    if @school_district.nil?
      return render_400(ErrorCode::INVALID_PARAM, '存在しない code を指定しています。')
    end
  end

  def validate_show_address_params
    enable_sort_keys = ['code', 'name']
    sort = params[:sort]
    if sort.present? && !is_enable_sort_key?(enable_sort_keys)
      return render_400(ErrorCode::INVALID_PARAM, 'sort の指定が誤っています。')
    end
  end

  def validate_show_school_district_params
    enable_sort_keys = ['code', 'school_name', 'address_code']
    sort = params[:sort]
    if sort.present? && !is_enable_sort_key?(enable_sort_keys)
      return render_400(ErrorCode::INVALID_PARAM, 'sort の指定が誤っています。')
    end
  end

  def get_school_districts
    # 検索条件
    name = params[:name]
    address_code = params[:address_code]
    school_type = params[:school_type]
    location = get_location
    radius = get_radius
    distance = "St_distance_sphere(ST_GeomFromText('POINT(#{location[:lng]} #{location[:lat]})', 4326), ST_GeomFromText(CONCAT('POINT(', longitude, ' ', latitude, ')'), 4326))" if location.present?
    sort = get_sort || [code: :asc]
    limit = get_limit
    offset = get_offset

    # 検索条件設定
    school_districts = SchoolDistrict
    school_districts = school_districts.where("MATCH (school_name) AGAINST ('+#{name}' IN BOOLEAN MODE)") if name.present?
    school_districts = school_districts.where('address_code LIKE ?', "#{address_code}%") if address_code.present?
    school_districts = school_districts.where(school_type: school_type) if school_type.present?
    school_districts = school_districts.order(sort)
    school_districts = school_districts.where("#{distance} <= #{radius}") if location.present?

    # 合計件数取得
    @total = school_districts.count

    # 取得範囲設定
    school_districts = school_districts.select("*, #{distance} as distance") if location.present?
    school_districts = school_districts.order(sort).offset(offset).limit(limit)

    @school_districts =school_districts
  end
end
