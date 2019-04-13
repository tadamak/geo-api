class V1::AddressesController < ApplicationController
  before_action :validate_code, only: [:show]

  def show
  end

  def search
    logger.debug 'search'
  end

  def validate_code
    code = params[:code]
    @address = Address.find_by(code: code)
    render status: :bad_request, json: { status: 400, message: 'Invalid address code.' } if @address.nil?
  end
end
