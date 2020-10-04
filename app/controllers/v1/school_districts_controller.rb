class V1::SchoolDistrictsController < ApplicationController
  include Swagger::SchoolDistrictsApi

  before_action :validate_index_params, only: [:index, :index_shape]
  before_action :validate_show_params, only: [:show, :show_shape, :show_address, :show_school_district]

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

  def show_address
    code = params[:code]
    filter = params[:filter]
    address_code = @school_district.address_code.slice(0, Address::CODE_DIGIT[:CITY])
    geo_addresses = GeoAddress.where(level: Address::LEVEL[:TOWN]).where('address_code LIKE ?', "#{address_code}%")
    subquery = "SELECT polygon FROM school_districts WHERE code = '#{code}'"
    if filter == SchoolDistrict::FILTER[:CONTAIN]
      geo_addresses = geo_addresses.where("ST_Contains((#{subquery}), polygon)")
    elsif filter == SchoolDistrict::FILTER[:PARTIAL]
      geo_addresses = geo_addresses.where("ST_Intersects((#{subquery}), polygon)")
                                   .where.not("ST_Touches((#{subquery}), polygon)")
                                   .where.not("ST_Contains((#{subquery}), polygon)")
    else
      geo_addresses = geo_addresses.where("ST_Intersects((#{subquery}), polygon)")
                                   .where.not("ST_Touches((#{subquery}), polygon)")
    end
    addresses = Address.where(code: geo_addresses.pluck(:address_code))
    render json: addresses
  end

  def show_school_district
    code = params[:code]
    filter = params[:filter]
    school_type = params[:school_type]
    address_code = @school_district.address_code.slice(0, Address::CODE_DIGIT[:CITY])
    subquery = "SELECT polygon FROM school_districts WHERE code = '#{code}'"
    school_districts = SchoolDistrict.select(:code, :address_code, :school_code, :school_name, :school_type, :school_address, :latitude, :longitude)
                                     .where('address_code LIKE ?', "#{address_code}%")
                                     .where.not(code: code)
    if filter == SchoolDistrict::FILTER[:CONTAIN]
      school_districts = school_districts.where("ST_Contains((#{subquery}), polygon)")
    elsif filter == SchoolDistrict::FILTER[:PARTIAL]
      school_districts = school_districts.where("ST_Intersects((#{subquery}), polygon)")
                                         .where.not("ST_Touches((#{subquery}), polygon)")
                                         .where.not("ST_Contains((#{subquery}), polygon)")
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
end
