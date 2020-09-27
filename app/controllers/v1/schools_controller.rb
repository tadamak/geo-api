class V1::SchoolsController < ApplicationController
  include Swagger::SchoolsApi

  before_action :validate_index_params, only: [:index]

  def index
    address_code = params[:address_code]
    school_type = params[:school_type]
    school_admin = params[:school_admin]

    schools = School.includes(:school_district).where('address_code LIKE ?', "#{address_code}%")
    schools = schools.where(school_type: school_type) unless school_type.blank?
    schools = schools.where(school_admin: school_admin) unless school_admin.blank?

    render json: schools
  end

  private

  def validate_index_params
    address_code = params[:address_code]
    if address_code.blank?
      return render_400(ErrorCode::REQUIRED_PARAM, 'address_code の指定が必要です。')
    elsif address_code.length != Address::CODE_DIGIT[:CITY]
      return render_400(ErrorCode::INVALID_PARAM, "address_code はレベル2(市区町村)を指定してください。")
    end
  end
end
