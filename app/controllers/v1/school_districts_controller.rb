class V1::SchoolDistrictsController < ApplicationController
  include Swagger::SchoolDistrictsApi

  before_action :validate_index_params, only: [:index, :index_shape]
  before_action :validate_show_params, only: [:show, :show_shape]

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

  def index_shape
    address_code = params[:address_code]
    school_type = params[:school_type]
    school_districts = SchoolDistrict.where('address_code LIKE ?', "#{address_code}%")
    school_districts = school_districts.where(school_type: school_type) unless school_type.nil?
    render json: school_districts.geojson
  end

  def show_shape
    code = params[:code]
    school_district = SchoolDistrict.where(code: code)
    render json: school_district.geojson
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
    school_district = SchoolDistrict.find_by(code: code)
    if school_district.nil?
      return render_400(ErrorCode::REQUIRED_PARAM, '存在しない code を指定しています。')
    end
  end
end