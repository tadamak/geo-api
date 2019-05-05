class V1::Analyses::AddressesController < ApplicationController
  include Swagger::AnalysesApi

  before_action :validate_contains_params, only: [:contains]

  def contains
    # TODO: validation
    locations = params[:locations]
    locations = JSON.parse(locations) if locations.kind_of?(String)
    level = params[:level]
    @count = GeoAddress.count_by_address_code(locations, level)
  end

  private

  def validate_contains_params
    locations = params[:locations]
    render status: :bad_request, json: { status: 400, message: 'Required locations.' } if locations.blank?
    level = params[:level]
    render status: :bad_request, json: { status: 400, message: 'Required level.' } if level.blank?
  end
end
