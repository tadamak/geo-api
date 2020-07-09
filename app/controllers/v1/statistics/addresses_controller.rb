class V1::Statistics::AddressesController < ApplicationController
  include Swagger::StatisticsApi

  def population
    head :ok
  end
end
