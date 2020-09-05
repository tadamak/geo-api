class V1::SchoolDistrictsController < ApplicationController
  include Swagger::SchoolDistrictsApi

  before_action :validate_params, only: [:index, :shapes]

  def index
    address_code = params[:address_code]
    school_type = params[:school_type]
    school_districts = SchoolDistrict.select(:address_code, :school_name, :school_type, :school_address, :latitude, :longitude).where(address_code: address_code)
    if school_type.present?
      school_districts = school_districts.where(school_type: school_type)
    end
    render json: school_districts
  end

  def shapes
    address_code = params[:address_code]
    school_type = params[:school_type]
    render json: SchoolDistrict.geojson(address_code, school_type)
  end

  private

  def validate_params
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
end
