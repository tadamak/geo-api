class V1::SchoolDistrictsController < ApplicationController
  include Swagger::SchoolDistrictsApi

  before_action :validate_index_params, only: [:index]
  before_action :validate_shapes_params, only: [:shapes]

  def index
    school_type = params[:school_type]
    school_districts = SchoolDistrict.select(:address_code, :school_name, :school_type, :school_address, :latitude, :longitude).where(address_code: params[:address_codes].split(','))
    if school_type.present?
      school_districts = school_districts.where(school_type: school_type)
    end
    render json: school_districts
  end

  def shapes
    address_codes = params[:address_codes].split(',')
    school_type = params[:school_type]
    render json: SchoolDistrict.geojson(address_codes, school_type)
  end

  private

  def validate_index_params
    codes = params[:address_codes]&.split(',')
    school_type = params[:school_type]
    if codes.blank?
      return render_400(ErrorCode::REQUIRED_PARAM, 'address_codes の指定が必要です。')
    elsif codes.length > Constants::MAX_LIMIT
      return render_400(ErrorCode::INVALID_PARAM, "address_codes の指定数が最大値(#{Constants::MAX_LIMIT}件)を超えています。")
    end
    if school_type.present? && !SchoolDistrict.school_types.values.include?(school_type.to_i)
      return render_400(ErrorCode::INVALID_PARAM, "誤った school_type を指定しています。")
    end
  end

  def validate_shapes_params
    codes = params[:address_codes]&.split(',')
    school_type = params[:school_type]
    if codes.blank?
      return render_400(ErrorCode::REQUIRED_PARAM, 'address_codes の指定が必要です。')
    elsif codes.length > Constants::MAX_LIMIT
      return render_400(ErrorCode::INVALID_PARAM, "address_codes の指定数が最大値(#{Constants::MAX_LIMIT}件)を超えています。")
    end
    if school_type.present? && !SchoolDistrict.school_types.values.include?(school_type.to_i)
      return render_400(ErrorCode::INVALID_PARAM, "誤った school_type を指定しています。")
    end
  end
end
