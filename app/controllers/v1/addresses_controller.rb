class V1::AddressesController < ApplicationController
  include Swagger::AddressesApi

  before_action :validate_show_params, only: [:show]
  before_action :validate_search_params, only: [:search]

  def show
  end

  def search
    if params[:word].present?
      @addresses = Address.where('name LIKE ?', "%#{params[:word]}%")
    elsif params[:code].present?
      search_level = get_search_level # 一階層下の住所レベルを取得
      @addresses = Address.where(level: search_level)
      @addresses = @addresses.where('code LIKE ?', "#{@address.code}%")
    end

    offset = get_offset
    limit = get_limit
    total = @addresses.unscope(:select).count
    @addresses = @addresses.offset(offset).limit(limit)

    response.headers['X-Total-Count'] = total
  end

  def validate_show_params
    code = params[:code]
    @address = Address.find_by(code: code)
    render status: :bad_request, json: { status: 400, message: 'Invalid address code.' } if @address.nil?
  end

  def validate_search_params
    word = params[:word]
    code = params[:code]

    if word.blank? && code.blank?
      render status: :bad_request, json: { status: 400, message: 'Parameter(word or code) is required.' }
      return
    end

    if code.present?
      @address = Address.find_by(code: code)
      render status: :bad_request, json: { status: 400, message: 'Invalid address code.' } if @address.nil?
    end
  end

  private

  def get_search_level
    if @address.nil?
      Address::LEVEL[:PREF]
    else
      @address.level + 1
    end
  end

  def get_limit
    limit = params[:limit].blank? ? Constants::DEFAULT_LIMIT : params[:limit].to_i
    limit = Constants::MAX_LIMIT if limit > Constants::MAX_LIMIT
    limit
  end

  def get_offset
    params[:offset].blank? ? Constants::DEFAULT_OFFSET : params[:offset].to_i
  end
end
