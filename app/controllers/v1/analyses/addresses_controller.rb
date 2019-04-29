class V1::Analyses::AddressesController < ApplicationController
  include Swagger::AnalysesApi

  before_action :validate_contains_params, only: [:contains]

  def contains
    # TODO: validation
    coordinates = params[:coordinates]
    coordinates = JSON.parse(coordinates) if coordinates.kind_of?(String)
    level = params[:level]
    @count = GeoAddress.count_by_address_code(coordinates, level)
  end

  private

  def validate_contains_params
    coordinates = params[:coordinates]
    render status: :bad_request, json: { status: 400, message: 'Required coordinates.' } if coordinates.blank?
    level = params[:level]
    render status: :bad_request, json: { status: 400, message: 'Required level.' } if level.blank?
  end
end
