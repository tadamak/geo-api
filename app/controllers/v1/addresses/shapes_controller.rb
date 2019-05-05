class V1::Addresses::ShapesController < ApplicationController
  include Swagger::AddressesApi

  before_action :validate_code, only: [:show]

  def show
    code = params[:code]
    @geojson = GeoAddress.geojson(code)
  end

  private

  def validate_code
    code = params[:code]
    geo_address = GeoAddress.find_by(address_code: code)
    render status: :bad_request, json: { status: 400, message: 'Invalid address code.' } if geo_address.nil?
  end
end