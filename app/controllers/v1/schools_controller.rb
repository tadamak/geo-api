class V1::SchoolsController < ApplicationController
  include Swagger::SchoolsApi

  before_action :validate_page_params, only: [:index]
  before_action :validate_index_params, only: [:index]
  before_action :validate_show_params, only: [:show]

  def index
    schools = get_schools
    total = schools.count
    schools = schools.offset(@offset).limit(@limit).order(address_code: :asc)
    response.headers['X-Total-Count'] = total

    render json: schools
  end

  def show
    render json: @school
  end

  private

  def validate_index_params
    address_code = params[:address_code]
    school_type = params[:school_type]
    school_admin = params[:school_admin]
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
    name = params[:name]
    address_code = params[:address_code]
    school_type = params[:school_type]
    school_admin = params[:school_admin]

    schools = School.includes(:school_district)
    schools = schools.where("MATCH (name) AGAINST ('+#{name}' IN BOOLEAN MODE)") if name.present?
    schools = schools.where('address_code LIKE ?', "#{address_code}%") if address_code.present?
    schools = schools.where(school_type: school_type) if school_type.present?
    schools = schools.where(school_admin: school_admin) if school_admin.present?

    return schools
  end
end
