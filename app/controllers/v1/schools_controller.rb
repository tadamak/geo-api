class V1::SchoolsController < ApplicationController
  include Swagger::SchoolsApi

  before_action :validate_page_params, only: [:index]
  before_action :validate_distance_params, only: [:index]
  before_action :validate_index_params, only: [:index]
  before_action :validate_show_params, only: [:show]
  before_action :get_schools, only: [:index]

  def index
    response.headers['X-Total-Count'] = @total
    render json: @schools
  end

  def show
    render json: @school
  end

  private

  def validate_index_params
    enable_sort_keys = ['code', 'name', 'address_code']
    enable_sort_keys << 'distance' if params[:location].present?
    sort = params[:sort]
    address_code = params[:address_code]
    school_type = params[:school_type]
    school_admin = params[:school_admin]
    if sort.present? && !is_enable_sort_key?(enable_sort_keys)
      return render_400(ErrorCode::INVALID_PARAM, 'sort の指定が誤っています。')
    end
    if address_code.present? && address_code.length != Address::CODE_DIGIT[:CITY]
      return render_400(ErrorCode::INVALID_PARAM, "address_code はレベル2(市区町村)を指定してください。")
    end
    if school_type.present? && !School.school_types.values.include?(school_type.to_i)
      return render_400(ErrorCode::INVALID_PARAM, "誤った school_type を指定しています。")
    end
    if school_admin.present? && !School.school_admins.values.include?(school_admin.to_i)
      return render_400(ErrorCode::INVALID_PARAM, "誤った school_admin を指定しています。")
    end
  end

  def validate_show_params
    code = params[:code]
    @school = School.find_by(code: code)
    if @school.nil?
      return render_400(ErrorCode::INVALID_PARAM, '存在しない code を指定しています。')
    end
  end

  def get_schools
    # 検索条件
    name = params[:name]
    address_code = params[:address_code]
    school_type = params[:school_type]
    school_admin = params[:school_admin]
    location = get_location
    radius = get_radius
    distance = "St_distance_sphere(ST_GeomFromText('POINT(#{location[:lng]} #{location[:lat]})', 4326), ST_GeomFromText(CONCAT('POINT(', longitude, ' ', latitude, ')'), 4326))" if location.present?
    sort = get_sort || [code: :asc]
    limit = get_limit
    offset = get_offset

    # 検索条件設定
    schools = School.includes(:school_district)
    schools = schools.where("MATCH (name) AGAINST ('+#{name}' IN BOOLEAN MODE)") if name.present?
    schools = schools.where('address_code LIKE ?', "#{address_code}%") if address_code.present?
    schools = schools.where(school_type: school_type) if school_type.present?
    schools = schools.where(school_admin: school_admin) if school_admin.present?
    schools = schools.where("#{distance} <= #{radius}") if location.present?

    # 合計件数取得
    @total = schools.count

    # 取得範囲設定
    schools = schools.select("*, #{distance} as distance") if location.present?
    schools = schools.order(sort).offset(offset).limit(limit)

    @schools =schools
  end
end
