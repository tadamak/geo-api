class V1::SchoolDistrictsController < ApplicationController
  include Swagger::SchoolDistrictsApi

  before_action :validate_index_params, only: [:index, :index_shapes]
  before_action :validate_show_params, only: [:show, :show_shapes]

  def index
    address_code = params[:address_code]
    school_type = params[:school_type]
    school_districts = SchoolDistrict.select(:id, :address_code, :school_name, :school_type, :school_address, :latitude, :longitude).where(address_code: address_code)
    if school_type.present?
      school_districts = school_districts.where(school_type: school_type)
    end
    render json: school_districts
  end
  
  def show
    id = params[:id]
    school_district = SchoolDistrict.select(:id, :address_code, :school_name, :school_type, :school_address, :latitude, :longitude).find_by(id: id)
    render json: school_district
  end

  def index_shapes
    address_code = params[:address_code]
    school_type = params[:school_type]
    school_districts = SchoolDistrict.where(address_code: address_code)
    school_districts = school_districts.where(school_type: school_type) unless school_type.nil?
    render json: school_districts.geojson
  end

  def show_shapes
    id = params[:id]
    school_district = SchoolDistrict.where(id: id)
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
    id = params[:id]
    school_district = SchoolDistrict.find_by(id: id)
    if school_district.nil?
      return render_400(ErrorCode::REQUIRED_PARAM, '存在しない id を指定しています。')
    end
  end
end
