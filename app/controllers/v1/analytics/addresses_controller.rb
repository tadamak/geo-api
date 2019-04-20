class V1::Analytics::AddressesController < ApplicationController
  def contains
    coordinates = JSON.parse(params[:coordinates])
    level = params[:level]
    @count = GeoAddress.count_by_address_code(coordinates, level)
  end
end
