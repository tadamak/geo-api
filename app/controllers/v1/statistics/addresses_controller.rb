class V1::Statistics::AddressesController < ApplicationController
  include Swagger::StatisticsApi

  def populations
    head :ok
  end
end
