class V1::Analytics::AddressesController < ApplicationController
  include Swagger::AnalyticsApi

  before_action :validate_contains_params, only: [:contains]

  def contains
    locations = params[:locations]
    locations = JSON.parse(locations) if locations.kind_of?(String)
    level = params[:level].to_i
    @counts_by_address_code = GeoAddress.counts_by_address_code(locations, level)
  end

  private

  def validate_contains_params
    locations = params[:locations]
    if locations.blank?
      return render_400(ErrorCode::REQUIRED_PARAM, 'locations の指定が必要です。')
    elsif locations.length > Constants::MAX_LIMIT
      return render_400(ErrorCode::INVALID_PARAM, "locations の指定数が最大値(#{Constants::MAX_LIMIT}件)を超えています。")
    end

    level = params[:level]
    if level.blank?
      return render_400(ErrorCode::REQUIRED_PARAM, 'level の指定が必要です。')
    end
  end
end
